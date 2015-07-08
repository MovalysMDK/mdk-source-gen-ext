/**
 * Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)
 *
 * This file is part of Movalys MDK.
 * Movalys MDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * Movalys MDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */
package com.adeuza.movalysfwk.mf4mdd.mbandroid.extractors;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import org.dom4j.Element;

import com.a2a.adjava.languages.android.AndroidTypes;
import com.a2a.adjava.uml.UmlModel;
import com.a2a.adjava.uml2xmodele.extractors.AbstractExtractor;
import com.a2a.adjava.xmodele.MAction;
import com.a2a.adjava.xmodele.MActionType;
import com.a2a.adjava.xmodele.MLayout;
import com.a2a.adjava.xmodele.MPage;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.ui.component.MAbstractButton;
import com.a2a.adjava.xmodele.ui.component.MNavigationButton;
import com.a2a.adjava.xmodele.ui.menu.MMenu;
import com.a2a.adjava.xmodele.ui.menu.MMenuActionItem;
import com.a2a.adjava.xmodele.ui.menu.MMenuItem;
import com.a2a.adjava.xmodele.ui.navigation.MNavigation;
import com.a2a.adjava.xmodele.ui.navigation.MNavigationType;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4ADictionnary;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4ADomain;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4AModeleFactory;

/**
 * <p>TODO Décrire la classe EventExtractor</p>
 *
 * <p>Copyright (c) 2012
 * <p>Company: Adeuza
 *
 * @author emalespine
 *
 */

public class ActionBarMMenuExtractor extends AbstractExtractor<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> {

	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.extractors.MExtractor#initialize(org.dom4j.Element)
	 */
	@Override
	public void initialize(Element p_xConfig) throws Exception {
		// NOTHING TO DO
	}

	/**
	 * {@inherit}
	 */
	@Override
	public void extract(UmlModel p_oModele) throws Exception {
		
		for (MScreen oScreen : this.getDomain().getDictionnary().getAllScreens()) {
			
			this.createActions(oScreen, oScreen.getPages());
			
		}
	}

	private void createActions(MScreen p_oScreen, List<MPage> p_oPages) {
		boolean hasTreatImports = false;
		for(MMenu oMenu : p_oScreen.getMenus()) {
			if(oMenu.getMenuItems() != null) {
				for(MMenuItem oMenuItem : oMenu.getMenuItems()) {
					if(oMenuItem.getNavigation().getNavigationType().equals(MNavigationType.NAVIGATION_MENU)) {
						p_oScreen.addImport(AndroidTypes.Intent.getImport());
						p_oScreen.addImport(MF4ATypes.ListenerOnMenuItemClick.getImport());
						hasTreatImports = true;
					}
					if(hasTreatImports)break;
				}
			}
			if(hasTreatImports)break;
		}
		
		MMenu oMMenu = p_oScreen.getMenu("actions");
		if (oMMenu == null) {
			oMMenu = new MMenu("actions");
		}
		
		// We only weep one action of each type dif on id
		Map<String, MMenuActionItem> oMapActionItem = new HashMap<>();
		
		// Add button Info
		if (p_oScreen.isComment()) {
			MNavigation oInfoNav = this.getDomain().getXModeleFactory().createNavigation("info", MNavigationType.NAVIGATION_INFO, p_oScreen, null);
			MNavigationButton oInfoNavBut = this.getDomain().getXModeleFactory().createNavigationButton("info", oInfoNav);
			MMenuActionItem oMMenuActionItem = this.getDomain().getXModeleFactory().createMenuActionItem(
					"actionmenu_"+p_oScreen.getName().toLowerCase()+"_"+ oInfoNav.getName().toLowerCase());
			oMMenuActionItem.addMenuAction(oInfoNavBut);
			oMapActionItem.put(oMMenuActionItem.getId(), oMMenuActionItem);
		}
		
		for (MPage mPage : p_oPages) {
			// generation de l'action de sauvegarde
			MAction oActionSave = mPage.getActionOfType(MActionType.SAVEDETAIL);
			if (oActionSave!=null) {
				addActionToMenu( "actionmenu_"+p_oScreen.getName().toLowerCase()+"_save", oActionSave, p_oScreen, oMapActionItem);
			}
			
			// generation de l'action de suppression
			MAction oActionDelete = mPage.getActionOfType(MActionType.DELETEDETAIL);
			if (oActionDelete!=null) {
				addActionToMenu( "actionmenu_"+p_oScreen.getName().toLowerCase()+"_delete", oActionDelete, p_oScreen, oMapActionItem);
			}
			
			// generation de l'action d'ajout (dans les navigation de l'adapter du layout de la page)
			if (mPage.getAdapter() != null) {
				for ( MLayout oLayout : mPage.getAdapter().getLayouts() ) {
					for (MAbstractButton oBtn : oLayout.getButtons()) {
						if (oBtn instanceof MNavigationButton) {
							
							MNavigationButton oNavBtn = (MNavigationButton) oBtn;
							// si la navigation est de type DETAIL ou WKS_SWITCHPANEL
							if (((MNavigationButton) oBtn).getNavigation().getNavigationType().equals(MNavigationType.NAVIGATION_DETAIL) || ((MNavigationButton) oBtn).getNavigation().getNavigationType().equals(MNavigationType.NAVIGATION_WKS_SWITCHPANEL) ) {
								MMenuActionItem oMMenuActionItem = this.getDomain().getXModeleFactory().createMenuActionItem(
										"actionmenu_"+p_oScreen.getName().toLowerCase()+"_"+oNavBtn.getName().toLowerCase());
								oMMenuActionItem.addMenuAction(oNavBtn);
								oMapActionItem.put(oMMenuActionItem.getId(), oMMenuActionItem);
							}
							
						}
					}
				}
			}
			
		}
		
		Map<String, MMenuActionItem> oTreeMapActionItem = new TreeMap<String, MMenuActionItem>(oMapActionItem);
		for (String oMenuItemKey : oTreeMapActionItem.keySet()) {
			oMMenu.addMenuItem(oTreeMapActionItem.get(oMenuItemKey));
		}
		
		if (!oMapActionItem.isEmpty()) {
			p_oScreen.addMenu(oMMenu);
		}
		
	}

	private void addActionToMenu( String sId, MAction oAction, MScreen p_oScreen,
			Map<String, MMenuActionItem> oMapActionItem ) {
		MMenuActionItem oMMenuActionItem = oMapActionItem.get(sId);
		if ( oMMenuActionItem == null ) {
			oMMenuActionItem = this.getDomain().getXModeleFactory().createMenuActionItem(sId);
			oMMenuActionItem.setScreen(p_oScreen);
			oMapActionItem.put(oMMenuActionItem.getId(), oMMenuActionItem);
		}
		oMMenuActionItem.addMenuAction(oAction);
	}
	
}
