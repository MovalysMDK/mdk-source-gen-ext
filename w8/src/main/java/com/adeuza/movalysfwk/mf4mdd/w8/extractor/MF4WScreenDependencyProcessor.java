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
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MPage;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.MVisualField;
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

	/**
	 * {@inheritDoc}
	 * @param p_oScreen
	 */
	@Override
	protected void setLayoutForSinglePageScreen(MScreen p_oScreen) {
		// Do not put the panel layout inside the screen layout
	}
}

