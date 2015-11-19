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
package com.adeuza.movalysfwk.mf4mdd.mbandroid.generator;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.generator.core.append.AbstractAppendGenerator;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.languages.android.xmodele.MAndroidProject;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.utils.VersionHandler;
import com.a2a.adjava.xmodele.MPage;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.XProject;
import com.a2a.adjava.xmodele.ui.menu.MMenu;
import com.a2a.adjava.xmodele.ui.menu.MMenuActionItem;
import com.a2a.adjava.xmodele.ui.menu.MMenuItem;
import com.a2a.adjava.xmodele.ui.navigation.MNavigationType;
import com.adeuza.movalysfwk.mf4mdd.commons.utils.Version;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4ADictionnary;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4ADomain;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4AModeleFactory;

/**
 * @author lmichenaud
 * 
 */
public class MenuGenerator extends
		AbstractAppendGenerator<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> {

	/**
	 * Xsl for menu
	 */
	private static final String RESMENU_XSL = "ui/menus/resmenu.xsl";
	
	/**
	 * Logger
	 */
	private static final Logger log = LoggerFactory
			.getLogger(MenuGenerator.class);

	/**
	 * (non-Javadoc)
	 * 
	 * @see com.a2a.adjava.generators.ResourceGenerator#genere(com.a2a.adjava.xmodele.XProject,
	 *      java.util.Map)
	 */
	@Override
	public void genere(
			XProject<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> p_oProject,
			DomainGeneratorContext p_oContext) throws Exception {

		log.debug("> MenuGenerator.genere");
		Chrono oChrono = new Chrono(true);

		MAndroidProject<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> oAndroidProject = 
				(MAndroidProject<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>>) p_oProject;
		
		for (MScreen oScreen : p_oProject.getDomain().getDictionnary()
				.getAllScreens()) {

			for (MMenu oMenu : oScreen.getMenus()) {

				// traitement spec to workspace
				this.handleActionOnWorkspace(p_oContext, oAndroidProject, oScreen,
						oMenu);

				if (!oMenu.getMenuItems().isEmpty()) {
					Element xMenu = oMenu.toXml();
					Document xDoc = DocumentHelper.createDocument(xMenu);

					xDoc.getRootElement().addElement("screenname-lc")
							.setText(oScreen.getName().toLowerCase());

					StringBuilder sFilename = new StringBuilder();
					sFilename.append(oScreen.getName().toLowerCase());
					sFilename.append('_');
					sFilename.append(oMenu.getId().toLowerCase());
					sFilename.append(".xml");

					File oTargetFile = new File(oAndroidProject.getMenuDir(),
							sFilename.toString());

					log.debug("  generate menu file: {}", sFilename);
					this.doAppendGeneration(xDoc, RESMENU_XSL,
							oTargetFile, p_oProject, p_oContext);
				}
			}

		}

		log.debug("< MenuGenerator.genere: {}", oChrono.stopAndDisplay());
	}

	private void handleActionOnWorkspace(
			DomainGeneratorContext p_oContext,
			MAndroidProject<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> p_oProject,
			MScreen p_oScreen, MMenu p_oMenu) throws Exception {
		
		List<MMenuItem> itemToRemove = new ArrayList<MMenuItem>();
		
		if (p_oScreen.isWorkspace()
				&& Version.GENERATION_V2_0_0
						.equals(VersionHandler.getGenerationVersion())) {
			MMenu oTempDetailMenu = new MMenu(p_oMenu.getId());
			MMenu oTempListMenu = new MMenu(p_oMenu.getId());
			for (MMenuItem oMenuItem : p_oMenu.getMenuItems()) {

				if (oMenuItem instanceof MMenuActionItem) {
					MMenuActionItem oActionMenu = (MMenuActionItem) oMenuItem;
					
					if (oActionMenu.getNavigationButton() != null
							&& (oActionMenu
									.getNavigationButton()
									.getNavigation()
									.getNavigationType()
									.equals(MNavigationType.NAVIGATION_WKS_SWITCHPANEL)
								|| oActionMenu
									.getNavigationButton()
									.getNavigation()
									.getNavigationType()
									.equals(MNavigationType.NAVIGATION_INFO))) {
						
						// we set the add option in the actionbar only on legacy widget generation
						// on mdk widget we will use an Android Floating Action Button
						oTempListMenu.addMenuItem(oActionMenu);
						// si le menuitem est ajouter dans un fichier le
						// supprimer
						itemToRemove.add(oMenuItem);
					} else if (!oActionMenu.getActions().isEmpty()) {
						oTempDetailMenu.addMenuItem(oActionMenu);
						// si le menuitem est ajouter dans un fichier le
						// supprimer
						itemToRemove.add(oMenuItem);
					} else {
						log.error(".???.");
					}

				}

			}
			if(!oTempDetailMenu.getMenuItems().isEmpty())
			{
				this.createActionDetailMenu(p_oContext, p_oProject, p_oScreen, oTempDetailMenu);
			}
			if(!oTempListMenu.getMenuItems().isEmpty())
			{
				this.createActionListMenu(p_oContext, p_oProject, p_oScreen, oTempListMenu);
			}
		}

		// remove here
		for (MMenuItem mMenuItem : itemToRemove) {
			p_oMenu.getMenuItems().remove(mMenuItem);
		}
	}

	private void createActionListMenu(
			DomainGeneratorContext p_oContext,
			MAndroidProject<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> p_oProject,
			MScreen p_oScreen, MMenu p_oMenu) throws Exception {
		
		// add menu to master
		for (MPage oPage : p_oScreen.getPages()) {
			if (oPage.getParameterValue("workspace-panel-type").equals("master")) {
				oPage.addMenu(p_oMenu);
			}
		}
		
		Element xMenu = p_oMenu.toXml();
		
		Document xDoc = DocumentHelper.createDocument(xMenu);

		xDoc.getRootElement().addElement("screenname-lc")
				.setText(p_oScreen.getName().toLowerCase());

		StringBuilder sFilename = new StringBuilder();
		sFilename.append(p_oScreen.getName().toLowerCase());
		sFilename.append("_list_");
		sFilename.append(p_oMenu.getId().toLowerCase());
		sFilename.append(".xml");

		File oTargetFile = new File(p_oProject.getMenuDir(), sFilename.toString());

		log.debug("  generate menu file: {}", sFilename);
		this.doAppendGeneration(xDoc, RESMENU_XSL, oTargetFile, p_oProject, p_oContext);
	}

	private void createActionDetailMenu(
			DomainGeneratorContext p_oContext,
			MAndroidProject<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> p_oProject,
			MScreen p_oScreen, MMenu p_oMenu) throws Exception {
		
		// get pages and add menu
		for (MPage oPage : p_oScreen.getPages()) {
			if (!oPage.getParameterValue("workspace-panel-type").equals("master")) {
				oPage.addMenu(p_oMenu);
			}
		}
		
		Element xMenu = p_oMenu.toXml();
		
		Document xDoc = DocumentHelper.createDocument(xMenu);

		xDoc.getRootElement().addElement("screenname-lc")
				.setText(p_oScreen.getName().toLowerCase());

		StringBuilder sFilename = new StringBuilder();
		sFilename.append(p_oScreen.getName().toLowerCase());
		sFilename.append("_detail_");
		sFilename.append(p_oMenu.getId().toLowerCase());
		sFilename.append(".xml");

		File oTargetFile = new File(p_oProject.getMenuDir(), sFilename.toString());

		log.debug("  generate menu file: {}", sFilename);
		this.doAppendGeneration(xDoc, RESMENU_XSL, oTargetFile, p_oProject, p_oContext);
	}
}
