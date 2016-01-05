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
package com.adeuza.movalysfwk.mf4mdd.w8.extractor;

import java.util.ArrayList;
import java.util.List;
import java.util.Map.Entry;

import com.a2a.adjava.languages.LanguageConfiguration;
import com.a2a.adjava.messages.MessageHandler;
import com.a2a.adjava.uml.UmlClass;
import com.a2a.adjava.uml2xmodele.extractors.ScreenExtractor;
import com.a2a.adjava.xmodele.*;
import com.a2a.adjava.xmodele.ui.component.MNavigationButton;
import com.a2a.adjava.xmodele.ui.navigation.MNavigation;
import com.a2a.adjava.xmodele.ui.navigation.MNavigationType;
import com.adeuza.movalysfwk.mf4mdd.w8.xmodele.MF4WNavigation;
import com.adeuza.movalysfwk.mf4mdd.w8.xmodele.MF4WViewModel;
import org.apache.commons.lang3.StringUtils;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import com.a2a.adjava.uml.UmlDictionary;
import com.a2a.adjava.uml.UmlUsage;
import com.a2a.adjava.uml2xmodele.ui.screens.PanelAggregation;
import com.a2a.adjava.uml2xmodele.ui.screens.ScreenContext;
import com.a2a.adjava.uml2xmodele.ui.screens.ScreenDependencyProcessor;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelType;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelTypeConfiguration;
import com.adeuza.movalysfwk.mf4mdd.w8.xmodele.MF4WPage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class MF4WScreenDependencyProcessor extends ScreenDependencyProcessor {

	/**
	 * Logger de classe
	 **/
	private static final Logger log = LoggerFactory.getLogger(ScreenExtractor.class);

	/**
	 * Singleton instance
	 */
	private static MF4WScreenDependencyProcessor instance = new MF4WScreenDependencyProcessor();

	/**
	 * Return singleton instance
	 * @return singleton instance
	 */
	public static MF4WScreenDependencyProcessor getInstance() {
		return instance;
	}

	/**
	 * {@inheritDoc}
	 * @param p_oScreenContext
	 * @param p_oUmlDict le dictionnaire de donnée de l'application
	 * @throws Exception
	 */
	public void treatScreenRelations( ScreenContext p_oScreenContext, UmlDictionary p_oUmlDict) throws Exception {
		super.treatScreenRelations(p_oScreenContext, p_oUmlDict);

		IDomain<IModelDictionary, IModelFactory> oDomain = p_oScreenContext.getDomain();
		IModelDictionary oDictionary = oDomain.getDictionnary();
		// Add the support of viewmodel tree
		for (UmlClass oScreenUmlClass : p_oScreenContext.getScreenUmlClasses(p_oUmlDict)) {
			MScreen oScreen = oDictionary.getScreen(oScreenUmlClass.getName());
			// For each panel, add the panel's viewmodel as a sub VM of the screen
			for (PanelAggregation oPanelAggregation : p_oScreenContext.getPanelAggregations(oScreenUmlClass)) {
				oScreen.getViewModel().addSubViewModel(
						oDictionary.getPanel(oPanelAggregation.getPanel().getName()).getViewModelImpl());
			}
		}
	}

	@Override
	protected void treatNavigationUsage( UmlUsage p_oNavigationUsage, MScreen p_oScreen, ScreenContext p_oScreenContext ) throws Exception {

		IDomain<IModelDictionary, IModelFactory> oDomain = p_oScreenContext.getDomain();

		MScreen oScreenEnd = oDomain.getDictionnary()
				.getScreen(p_oNavigationUsage.getSupplier().getName());
		log.debug("treat navigation usage between {} and {}", p_oScreen.getName(), oScreenEnd.getName());

		if (p_oScreen.getPageCount() > 1) {
			// à voir comment le traiter mais pour le momment il
			// faudrait mettre un bouton de navigation sur chaque
			// page donc pas top.
			MessageHandler.getInstance().addError(
					"Cas non traité : navigation à partir de plusieurs pages, que faire ?");

		} else {

			MNavigation oNav = oDomain.getXModeleFactory().createNavigation("navigation",
					MNavigationType.NAVIGATION, p_oScreen, oScreenEnd);

			oDomain.getDictionnary().registerNavigation(oNav);

			if (!p_oScreen.hasMasterPage()) {

				// If navigation to screen with panel, use panel name to compute button name.
				// If navigation to a menu screen, use screen name to compute button name.

				String sButtonSuffix = oScreenEnd.getUmlName();

				MNavigationButton oNavButton =
						p_oScreenContext.getDomain().getXModeleFactory().createNavigationButton(
								StringUtils.join("button_navigate_", sButtonSuffix),
								StringUtils.join("button_navigate_", sButtonSuffix),
								sButtonSuffix, oNav);
				p_oScreen.getLayout().addButton(oNavButton);
				p_oScreen.addImport(oScreenEnd.getFullName());

				((MF4WViewModel)p_oScreen.getViewModel()).addNavigation((MF4WNavigation)oNav);
			}
		}
	}

	@Override
	protected void treatNavigationDetailUsage( UmlUsage p_oNavigationUsage, List<PanelAggregation> p_listPanelAggregations,
											   MScreen p_oScreen, ScreenContext p_oScreenContext ) {

		IDomain<IModelDictionary, IModelFactory> oDomain = p_oScreenContext.getDomain();
		MScreen oScreenEnd = oDomain.getDictionnary().getScreen(p_oNavigationUsage.getSupplier().getName());

		log.debug("treat navigation detail usage, screen:{}, navigation name: {}", p_oScreen.getName(), p_oNavigationUsage.getName());
		log.debug("  panel aggregation count: {}", p_listPanelAggregations.size());

		// une navigation de type détail est liée à un model par son
		// nom indiquant le type de l'élément à afficher
		// on cherche si le nom du usage est également le nom d'une
		// relation vers le view model.
		// Un usage navigationdetail (entre screen1 et screen2) est
		// lié à une relation "aggregation panel" de type list (entre
		// screen1 et panel1).
		for (PanelAggregation oPanelAggregation : p_listPanelAggregations) {

			// on recherche le liens entre les navigations
			if (oPanelAggregation.getName().equals(p_oNavigationUsage.getName())) {

				log.debug("relation between panel and screen found. Panel: {}",
						p_oNavigationUsage.getSupplier().getFullName());

				if (p_oScreen.getPageCount() > 1) {
					MessageHandler
							.getInstance()
							.addError(
									"Cas non traité : naviagtion à partir de plusieurs pages, que faire ?");
				} else {

					if (oScreenEnd.getPageCount() == 1) {

						// recopy current item key name to
						// screen target
						oScreenEnd
								.getMasterPage()
								.getViewModelImpl()
								.setCurrentItemKeyName(
										p_oScreen.getMasterPage().getViewModelImpl()
												.getCurrentItemKeyName());

						// il faut que le detail de la liste
						// oScreenEnd possède toutes les
						// cascades de l'affichage de la liste
						// oScreen
						log.debug("cascade : {}",
								p_oScreen.getMasterPage().getViewModelImpl()
										.getLoadCascades().size());
						MViewModelImpl oVmImpl = p_oScreen.getMasterPage().getViewModelImpl()
								.getSubViewModels().get(0);
						MViewModelImpl oVmImplEnd = oScreenEnd.getMasterPage()
								.getViewModelImpl();
						boolean bAdd = false;
						for (MCascade oCascade : oVmImpl.getLoadCascades()) {
							log.debug("search cascade {}", oCascade.getName());
							if (!oVmImplEnd.getLoadCascades().contains(oCascade)) {
								log.debug("not found !!!");
								oVmImplEnd.getLoadCascades().add(oCascade);
								bAdd = true;
							}
						}
						if (bAdd) {
							for (String sCascade : oVmImpl.getImportCascades()) {
								if (!oVmImplEnd.getImportCascades().contains(sCascade)) {
									oVmImplEnd.getImportCascades().add(sCascade);
								}
							}
						}

						MNavigation oNavDetail =
								oDomain.getXModeleFactory().createNavigation("navigationdetail",
										MNavigationType.NAVIGATION_DETAIL, p_oScreen, oScreenEnd);
						oNavDetail.setSourcePage(p_oScreen.getPageByName(oPanelAggregation.getPanel().getName()));
						oDomain.getDictionnary().registerNavigation(oNavDetail);

						log.debug("  add navigation detail on page: {}", p_oScreen.getMasterPage().getName());
						p_oScreen.getMasterPage().addNavigation(oNavDetail);

						p_oScreen.getMasterPage().getAssociatedDetails().addAll(oScreenEnd.getPages());

						((MF4WViewModel)p_oScreen.getViewModel()).addNavigation((MF4WNavigation)oNavDetail);
					} else {

						MessageHandler.getInstance().addError(
								"Cas non traité : l'écran de destination à plusieurs pages");

					}
				}
				break;
			}
		}
	}

	/**
	 * {@inheritDoc}
	 * @param p_oScreen
	 */
	@Override
	protected void setLayoutForSinglePageScreen(MScreen p_oScreen) {
		// Do not put the panel layout inside the screen layout
	}
}

