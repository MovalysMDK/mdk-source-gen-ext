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

import java.util.Iterator;

import org.dom4j.Element;

import com.a2a.adjava.uml.UmlModel;
import com.a2a.adjava.uml2xmodele.extractors.AbstractExtractor;
import com.a2a.adjava.xmodele.MAction;
import com.a2a.adjava.xmodele.MActionType;
import com.a2a.adjava.xmodele.MPage;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.ui.navigation.MNavigation;
import com.a2a.adjava.xmodele.ui.navigation.MNavigationType;
import com.a2a.adjava.xmodele.ui.panel.MPanelOperation;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4AActionInterface;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4ADictionnary;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4ADomain;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4AEvent;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4AEventType;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4AModeleFactory;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4AScreen;

/**
 * <p>TODO Décrire la classe EventExtractor</p>
 *
 * <p>Copyright (c) 2012
 * <p>Company: Adeuza
 *
 * @author emalespine
 *
 */

public class EventExtractor extends AbstractExtractor<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> {

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
		MNavigation oNavigationDetail = null;
		boolean bCreateAction = false;

		Iterator<MPage> iterPages = null;
		MPage oPage = null;

		Iterator<MPanelOperation> iterPanelOperations = null;
		for (MScreen oScreen : this.getDomain().getDictionnary().getAllScreens()) {
			iterPages = oScreen.getPages().iterator();
			while (iterPages.hasNext()) {
				oPage = iterPages.next();
				switch (oPage.getViewModelImpl().getType()) {
					case LIST_1:
					case LIST_2:
					case LIST_3:
						bCreateAction = false;
						// Si action de create sur la liste alors ajout event onAdd sur action de sauvegarde du detail
						iterPanelOperations = oPage.getPanelOperations().iterator();
						while (iterPanelOperations.hasNext()) {
							if (iterPanelOperations.next().getName().startsWith("create")) {
								bCreateAction = true;
								break;
							}
						}

						if (oScreen.isWorkspace()) { // Dans le cas du workspace, la première page correspond tjs à la liste, les pages suivantes aux détails.
							while (iterPages.hasNext()) {
								this.extractEventOfPage(iterPages.next(), (MF4AScreen) oScreen, bCreateAction);
							}
						}
						else {
							oNavigationDetail = oPage.getNavigationOfType(MNavigationType.NAVIGATION_DETAIL);
							if (oNavigationDetail != null) {
								this.extractEventOfPage(oNavigationDetail.getTargetPage(), (MF4AScreen) oScreen, bCreateAction);
							}
						}
						break;
				}
			}
		}
	}

	/**
	 * Extrait les évènements d'une page
	 * @param p_oPage
	 * @param p_oScreen
	 * @param p_bCreateAction
	 */
	public void extractEventOfPage(MPage p_oPage, MF4AScreen p_oScreen, boolean p_bCreateAction) {
		// Récupération de l'action de sauvegarde.
		// Ajout d'une référence sur l'écran aux évènements de cette action de sauvegarde
		MAction oAction = p_oPage.getActionOfType(MActionType.SAVEDETAIL);
		if (oAction != null) {
			MF4AActionInterface oActionInterface = (MF4AActionInterface) oAction.getMasterInterface();
			MF4AEvent oEvent = new MF4AEvent(oActionInterface, MF4AEventType.onchange);
			oActionInterface.addEvent(oEvent);
			p_oScreen.addListenEvents(oEvent);
			if (p_bCreateAction) {
				oEvent = new MF4AEvent(oActionInterface, MF4AEventType.onadd);
				oActionInterface.addEvent(oEvent);
				p_oScreen.addListenEvents(oEvent);
			}
		}

		oAction = p_oPage.getActionOfType(MActionType.DELETEDETAIL);
		if (oAction != null) {
			MF4AActionInterface oActionInterface = (MF4AActionInterface) oAction.getMasterInterface();
			MF4AEvent oEvent = new MF4AEvent(oActionInterface, MF4AEventType.ondelete);
			oActionInterface.addEvent(oEvent);
			p_oScreen.addListenEvents(oEvent);
		}
	}
}
