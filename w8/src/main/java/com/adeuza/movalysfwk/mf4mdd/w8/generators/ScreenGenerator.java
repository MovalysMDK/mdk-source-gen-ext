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
package com.adeuza.movalysfwk.mf4mdd.w8.generators;

import com.a2a.adjava.xmodele.ui.menu.MMenu;
import com.a2a.adjava.xmodele.ui.menu.MMenuItem;
import com.adeuza.movalysfwk.mf4mdd.w8.xmodele.MF4WNavigation;
import com.adeuza.movalysfwk.mf4mdd.w8.xmodele.MF4WViewModel;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.generator.core.incremental.AbstractIncrementalGenerator;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.utils.FileTypeUtils;
import com.a2a.adjava.xmodele.MLayout;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.MVisualField;
import com.a2a.adjava.xmodele.SGeneratedElement;
import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFDomain;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelDictionary;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelFactory;

/**
 * <p>
 * Generate Xaml layout for win 8
 * </p>
 * 
 * <p>
 * Copyright (c) 2011
 * <p>
 * Company: Adeuza
 * 
 * @author xbreysse
 * 
 */

public class ScreenGenerator
		extends
		AbstractIncrementalGenerator<MFDomain<MFModelDictionary, MFModelFactory>> {

	/**
	 * Logger
	 */
	private static final Logger log = LoggerFactory
			.getLogger(ScreenGenerator.class);

	/**
	 * Template for xaml screen
	 */
	private static final String XAML_SCREEN_TEMPLATE = "xaml-screen";
	
	/**
	 * Template for xaml layout
	 */
	private static final String XAML_LAYOUT_TEMPLATE = "xaml-layout";
	
	/**
	 * Current template
	 */
	private static String XAML_CURRENT_TEMPLATE;

	@Override
	public void genere(
			XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject,
			DomainGeneratorContext p_oGeneratorContext) throws Exception {
		log.debug("> ScreenGenerator.genere");
		Chrono oChrono = new Chrono(true);
		for (MScreen oMScreen : p_oMProject.getDomain().getDictionnary().getAllScreens()) {
			this.CreateXamlLayout(oMScreen, p_oMProject, p_oGeneratorContext);
		}
		log.debug("< ScreenGenerator.genere: {}", oChrono.stopAndDisplay());
	}

	/**
	 * Create layout xaml
	 * 
	 * @param p_oScreen
	 *            layout
	 * @param p_oMProject
	 *            project
	 * @param p_oContext
	 *            context
	 * @throws Exception
	 */
	protected void CreateXamlLayout(MScreen p_oScreen,
			XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject,
			DomainGeneratorContext p_oContext) throws Exception {
		String sXamlLayoutFile = this.getXamlFileName(p_oScreen, p_oMProject);
		Element xXamlLayout;
		if(p_oScreen.getPageCount() > 0)
		{
			this.setScreenTemplate(p_oMProject);
			xXamlLayout = this.computeXmlForXamlLayout(p_oScreen, p_oMProject);
			xXamlLayout.addElement("page-package").setText(p_oScreen.getPages().get(0).getPackage().getFullName());
		}
		else
		{
			this.setLayoutTemplate(p_oMProject);
			ComputeVisualFieldPosition(p_oScreen.getLayout());
			xXamlLayout = this.computeXmlForXamlLayout(p_oScreen.getLayout(), p_oMProject);
			xXamlLayout.addElement("screen-name").setText(p_oScreen.getName());
			if(p_oScreen.isMain())
				xXamlLayout.addElement("main-screen").setText("true");
			else
				xXamlLayout.addElement("main-screen").setText("false");
			xXamlLayout.addElement("package").setText(p_oScreen.getPackage().getFullName());

			// Add menus to the XML description
			Element xMenuElement = DocumentHelper.createElement("menus");
			for (MMenu menu : p_oScreen.getMenus()) {
				xMenuElement.add(menu.toXml());
            }
            xXamlLayout.add(xMenuElement);
		}
		xXamlLayout.add(AddPlatformAttribute(p_oMProject));
		log.debug("generation du fichier {}", sXamlLayoutFile);
		this.doIncrementalTransform(this.getCurrentTemplate(), sXamlLayoutFile,
				DocumentHelper.createDocument(xXamlLayout), p_oMProject, p_oContext);
	}

    /**
     * Get filename for xaml layout
     * @param p_oElement element
     * @param p_oMProject project
     * @return filename for xaml laout
     */
	protected String getXamlFileName(SGeneratedElement p_oElement,
			XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) {
		return FileTypeUtils.computeFilenameForXaml("View/Screens",
				p_oElement.getName(), p_oMProject.getSourceDir());
	}

	/**
	 * Compute xml node of the xaml layout
	 * 
	 * @param p_oElement
	 * @return xml
	 */
	protected Element computeXmlForXamlLayout(SGeneratedElement p_oElement,
			XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) {
		Element r_xFile = p_oElement.toXml();
		r_xFile.addElement("master-package").setText(p_oMProject.getDomain().getRootPackage());
		return r_xFile;
	}

	/**
	 * Get template for xaml layout
	 * 
	 * @return template for xaml layout
	 */
	protected void setLayoutTemplate(XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) {
		XAML_CURRENT_TEMPLATE = XAML_LAYOUT_TEMPLATE + ".xsl";
	}
	
	/**
	 * Get template for xaml screen
	 * 
	 * @return template for xaml screen
	 */
	protected void setScreenTemplate(XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) {
		XAML_CURRENT_TEMPLATE = XAML_SCREEN_TEMPLATE + ".xsl";
	}
	
	/**
	 * Get current template
	 * 
	 * @return current template
	 */
	protected String getCurrentTemplate() {
		return XAML_CURRENT_TEMPLATE;
	}
	
	protected void ComputeVisualFieldPosition(MLayout p_oLayout)
	{
		int count = 1;
		for(MVisualField visualField : p_oLayout.getFields()){
			if(visualField.isCreateLabel()){
				visualField.setLabelPosition(Integer.toString(count));
				count += 1;
			}
			visualField.setComponentPosition(Integer.toString(count));
			count += 1;
		}
	}
	
//	protected Element AddMenuToXml(MScreen p_oScreen)
//	{
//		Element xMenuElement = DocumentHelper.createElement("menus");
//		for(MMenu menu : p_oScreen.getMenus()){
//			xMenuElement.add(menu.toXml());
//		}
//		return xMenuElement;
//	}
	
	protected Element AddPlatformAttribute(XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) {
		Element r_oMenuElement = DocumentHelper.createElement("is-Store");
		if (p_oMProject.getSourceDir().contains("Store"))
		{
			r_oMenuElement.setText("true");	
		} else {
			r_oMenuElement.setText("false");	
		}
		return r_oMenuElement;
	}
}