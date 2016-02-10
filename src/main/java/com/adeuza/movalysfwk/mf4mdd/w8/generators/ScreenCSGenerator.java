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

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.generator.core.incremental.AbstractIncrementalGenerator;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.utils.FileTypeUtils;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.SGeneratedElement;
import com.a2a.adjava.xmodele.XProject;
import com.a2a.adjava.xmodele.ui.menu.MMenu;
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

public class ScreenCSGenerator
		extends
		AbstractIncrementalGenerator<MFDomain<MFModelDictionary, MFModelFactory>> {

	/**
	 * Logger
	 */
	private static final Logger log = LoggerFactory
			.getLogger(ScreenCSGenerator.class);

	/**
	 * Template for Phone CS layout
	 */
	private static final String PHONE_CS_LAYOUT_TEMPLATE = "ui/cs-layout";
	
	/**
	 * Template for Store CS layout
	 */
	private static final String STORE_CS_LAYOUT_TEMPLATE = "ui/cs-layout";
	/**
	 * Template for Phone CS screen
	 */
	private static final String PHONE_CS_SCREEN_TEMPLATE = "ui/cs-screen";
	
	/**
	 * Template for Store CS screen
	 */
	private static final String STORE_CS_SCREEN_TEMPLATE = "ui/cs-screen";
	
	/**
	 * Current template
	 */
	private static String CS_CURRENT_TEMPLATE;

	@Override
	public void genere(
			XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject,
			DomainGeneratorContext p_oGeneratorContext) throws Exception {
		log.debug("> Generate Xaml CS layout");
		Chrono oChrono = new Chrono(true);
		for (MScreen oMScreen : p_oMProject.getDomain().getDictionnary().getAllScreens()) {
			this.CreateCSLayout(oMScreen, p_oMProject, p_oGeneratorContext);
		}
		log.debug("< LayoutGenerator.genere: {}", oChrono.stopAndDisplay());
	}

	/**
	 * Create layout CS
	 * 
	 * @param p_oLayout
	 *            layout
	 * @param p_oMProject
	 *            project
	 * @param p_oContext
	 *            context
	 * @throws Exception
	 */
	protected void CreateCSLayout(MScreen p_oScreen,
			XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject,
			DomainGeneratorContext p_oContext) throws Exception {
		String sCSLayoutFile = this.getCSFileName(p_oScreen, p_oMProject);
		Document xCSLayout;
		if(p_oScreen.getPageCount() == 0)
		{
			if (p_oMProject.getSourceDir().contains("Store"))
			{
				this.setStoreLayoutTemplate(p_oMProject);
			}
			else
			{
				this.setPhoneLayoutTemplate(p_oMProject);
			}
			xCSLayout = this.computeXmlForCSLayout(p_oScreen,p_oScreen.getLayout(), p_oMProject);		
		}
		else
		{
			if (p_oMProject.getSourceDir().contains("Store"))
			{
				this.setStoreScreenTemplate(p_oMProject);
			}
			else
			{
				this.setPhoneScreenTemplate(p_oMProject);
			}
			xCSLayout = this.computeXmlForCSLayout(p_oScreen,p_oScreen, p_oMProject);

		}
		xCSLayout.getRootElement().add(AddMenuToXml(p_oScreen));			
		log.debug("generation du fichier {}", sCSLayoutFile);
		this.doIncrementalTransform(this.getCurrentTemplate(), sCSLayoutFile,
				xCSLayout, p_oMProject, p_oContext);
	}

	/**
	 * Get filename for xaml CS layout
	 * 
	 * @param p_oLayout
	 *            layout
	 * @param p_oMProject
	 *            project
	 * @return file name for layout
	 */
	protected String getCSFileName(SGeneratedElement p_oElement,
			XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) {
//		return FileTypeUtils.computeFilenameForXamlCSharpImpl("View/Screens",
				return FileTypeUtils.computeFilenameForXamlCSharpImpl("View/Screens",			
				p_oElement.getName(), p_oMProject.getSourceDir());
	}

	/**
	 * Compute xml node of the xaml CS layout
	 * 
	 * @param p_oDataLoader
	 *            layout
	 * @return xml
	 */
	protected Document computeXmlForCSLayout(MScreen p_oScreen,SGeneratedElement p_oElement,
			XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) {
		Element r_xFile = p_oElement.toXml();
		
		if (p_oMProject.getSourceDir().contains("Store"))
		{
			r_xFile.addElement("is-store").setText("true");	
		} else {
			r_xFile.addElement("is-store").setText("false");	
		}
		
		r_xFile.addElement("package").setText(p_oScreen.getPackage().getFullName());			
		r_xFile.addElement("screen-name").setText(p_oScreen.getName());
		if(p_oScreen.getPageCount() > 0) {
			r_xFile.addElement("page-package").setText(p_oScreen.getPages().get(0).getPackage().getFullName());
		}
	//r_xFile.addElement("master-package").setText(p_oMProject.getDomain().getRootPackage());
		Document xCSLayout = DocumentHelper.createDocument(r_xFile);
		return xCSLayout;
	}

	/**
	 * Get template for xaml CS layout
	 * 
	 * @return template for xaml CS layout
	 */
//	protected void setLayoutTemplate() {
//		CS_CURRENT_TEMPLATE = CS_LAYOUT_TEMPLATE;
//	}
	
	/**
	 * Get template for xaml CS screen
	 * 
	 * @return template for xaml CS screen
	 */
	protected void setStoreLayoutTemplate(XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) {
		CS_CURRENT_TEMPLATE = STORE_CS_LAYOUT_TEMPLATE + ".xsl";
	}

	protected void setPhoneLayoutTemplate(XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) {
		CS_CURRENT_TEMPLATE = PHONE_CS_LAYOUT_TEMPLATE + ".xsl";
	}
	protected void setStoreScreenTemplate(XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) {
		CS_CURRENT_TEMPLATE = STORE_CS_SCREEN_TEMPLATE + ".xsl";
	}

	protected void setPhoneScreenTemplate(XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) {
		CS_CURRENT_TEMPLATE = PHONE_CS_SCREEN_TEMPLATE + ".xsl";
	}
	
	/**
	 * Get current template
	 * 
	 * @return current template
	 */
	protected String getCurrentTemplate() {
		return CS_CURRENT_TEMPLATE;
	}
	
	
	protected Element AddMenuToXml(MScreen p_oScreen)
	{
		Element xMenuElement = DocumentHelper.createElement("menus");
		for(MMenu menu : p_oScreen.getMenus()){
			xMenuElement.add(menu.toXml());
		}
		return xMenuElement;
	}
}