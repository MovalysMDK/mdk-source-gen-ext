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
import java.util.List;
import java.util.Locale;
import java.util.Map;

import com.a2a.adjava.xmodele.MEnumeration;
import com.a2a.adjava.xmodele.MLabel;
import com.a2a.adjava.xmodele.MLayout;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.MVisualField;
import com.a2a.adjava.xmodele.XProject;
import com.a2a.adjava.xmodele.ui.component.MAbstractButton;
import com.a2a.adjava.xmodele.ui.component.MButtonType;
import com.a2a.adjava.xmodele.ui.menu.MMenu;
import com.a2a.adjava.xmodele.ui.menu.MMenuActionItem;
import com.a2a.adjava.xmodele.ui.menu.MMenuItem;
import com.adeuza.movalysfwk.mf4mdd.commons.generator.AbstractLabelGenerator;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4ADictionnary;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4ADomain;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4AModeleFactory;

/**
 * <p>
 * Generate properties of view models
 * </p>
 * 
 * <p>
 * Copyright (c) 2011
 * <p>
 * Company: Adeuza
 * 
 * @author smaitre
 * 
 */

public class LabelGenerator extends AbstractLabelGenerator<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> {
	
	/**
	 * Generated file
	 */
	private static final String GENERATED_FILE = "dev__project__labels.xml";

	/**
	 * {@inheritDoc}
	 */
	@Override
	protected void genLabels( Map<String,MLabel> p_mapLabels, XProject<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> p_oMProject, Locale p_oLocale) throws Exception {
		this.genLabelsFromDictionary(p_mapLabels, p_oMProject);
		this.genLabelsForLayout(p_mapLabels, p_oMProject);
		this.genLabelsForMenu(p_mapLabels, p_oMProject);
		this.genLabelsForEnumerations(p_mapLabels, p_oMProject);
	}

	/**
	 * Generate labels for layout : fields end buttons
	 * @param p_mapLabels labels 
	 * @param p_oMProject
	 * @throws Exception
	 */
	private void genLabelsForLayout(Map<String,MLabel> p_mapLabels, XProject<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> p_oMProject) throws Exception {
		if (!p_oMProject.getDomain().getDictionnary().getAllLayouts().isEmpty()) {

			for (MLayout oLayout : p_oMProject.getDomain().getDictionnary().getAllLayouts()) {
				for (MVisualField oField : oLayout.getFields()) {
					if (oField.isCreateLabel()) {
						MLabel oLabel = p_oMProject.getDomain().getXModeleFactory().createLabelForField(oField);
						p_mapLabels.put(oLabel.getKey(), oLabel);
					}
				}
				for(MAbstractButton oButton : oLayout.getButtons()) {
					if (oButton.getButtonType().equals(MButtonType.NAVIGATION)) {
						MLabel oLabel = p_oMProject.getDomain().getXModeleFactory().createLabelForButton(
								oButton.getLabelId(), oButton.getLabelValue());
						p_mapLabels.put(oLabel.getKey(), oLabel);
					}
				}
				if (oLayout.getTitle() != null) {
					MLabel oLabel = p_oMProject.getDomain().getXModeleFactory().createLabelForLayoutTitle(oLayout);
					p_mapLabels.put(oLabel.getKey(), oLabel);
				}
			}
		}
	}
	
	/**
	 * Generate labels for enumerations
	 * @param p_mapLabels labels 
	 * @param p_oMProject
	 * @throws Exception
	 */
	private void genLabelsForEnumerations(Map<String,MLabel> p_mapLabels, XProject<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> p_oMProject) throws Exception {
		if (!p_oMProject.getDomain().getDictionnary().getAllEnumerations().isEmpty()) {

			for (MEnumeration oEnum : p_oMProject.getDomain().getDictionnary().getAllEnumerations()) {
				p_mapLabels.putAll(p_oMProject.getDomain().getXModeleFactory().createLabelsForEnumeration(oEnum));
			}
		}
	}

	/**
	 * @param p_xLabels
	 * @param p_oMProject
	 * @throws Exception
	 */
	private void genLabelsForMenu(Map<String,MLabel> p_mapLabels, XProject<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> p_oMProject) throws Exception {

		for (MScreen oScreen : p_oMProject.getDomain().getDictionnary().getAllScreens()) {

			for (MMenu oMenu : oScreen.getMenus()) {

				for (MMenuItem oMenuItem : oMenu.getMenuItems()) {
					
					if (oMenuItem instanceof MMenuActionItem) {
						MMenuActionItem oMMenuActionItem = (MMenuActionItem) oMenuItem;
						MLabel oLabel = p_oMProject.getDomain().getXModeleFactory().createLabelForMenuActionItem(
								oMMenuActionItem, oMenu, oScreen);
						p_mapLabels.put(oLabel.getKey(), oLabel);
					} else {
						MLabel oLabel = p_oMProject.getDomain().getXModeleFactory().createLabelForMenuItem(oMenuItem, oMenu, oScreen);
						p_mapLabels.put(oLabel.getKey(), oLabel);
					}
					
				}
			}
			
			MLabel oLabel = p_oMProject.getDomain().getXModeleFactory().createLabelForScreen(oScreen);
			p_mapLabels.put(oLabel.getKey(), oLabel);
		}
		
	}
		
	/**
	 * Return output file for xsl generation
	 * @param p_oProject project
	 * @return output file
	 */
	protected File getOutputFile( XProject<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> p_oProject, Locale p_oLocale ) {
		return new File(p_oProject.getStringDir(), GENERATED_FILE);
	}
}