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
 * Generate the Xaml.cs file of Xaml layouts for Windows 8.1
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
public class ScreenCSGenerator extends AbstractIncrementalGenerator<MFDomain<MFModelDictionary, MFModelFactory>> {

	/**
	 * Logger instance
	 */
	private static final Logger log = LoggerFactory
			.getLogger(ScreenCSGenerator.class);

	/**
	 * XSL Template for Phone CS layout
	 */
	private static final String PHONE_CS_LAYOUT_XSL_TEMPLATE = "ui/cs-layout.xsl";

	/**
	 * XSL Template for Store CS layout
	 */
	private static final String STORE_CS_LAYOUT_XSL_TEMPLATE = "ui/cs-layout.xsl";
	/**
	 * XSL Template for Phone CS screen
	 */
	private static final String PHONE_CS_SCREEN_XSL_TEMPLATE = "ui/cs-screen.xsl";

	/**
	 * XSL Template for Store CS screen
	 */
	private static final String STORE_CS_SCREEN_XSL_TEMPLATE = "ui/cs-screen.xsl";

	/**
	 * Currently selected XSL template
	 */
	private static String selectedXslTemplate;

	/**
	 * {@inheritDoc}
	 * @param p_oMProject
	 * @param p_oGeneratorContext
	 * @throws Exception
	 */
	@Override
	public void genere(
			XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject,
			DomainGeneratorContext p_oGeneratorContext) throws Exception {

		log.debug("> Generate Xaml CS layout");
		Chrono oChrono = new Chrono(true);

		// Apply the generator for each MScreen (which can be either a Screen layout, or a standard layout)
		for (MScreen oMScreen : p_oMProject.getDomain().getDictionnary().getAllScreens()) {
			this.CreateCSLayout(oMScreen, p_oMProject, p_oGeneratorContext);
		}

		log.debug("< LayoutGenerator.genere: {}", oChrono.stopAndDisplay());
	}

	/**
	 * Create .xaml.cs layout file
	 *
	 * @param p_oScreen
	 *            screen
	 * @param p_oMProject
	 *            project
	 * @param p_oContext
	 *            context
	 * @throws Exception
	 */
	protected void CreateCSLayout(MScreen p_oScreen,
	                              XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject,
	                              DomainGeneratorContext p_oContext) throws Exception {

		String sCSLayoutFile;
		Document xCSLayout;

		// Compute the *.xaml.cs file name
		sCSLayoutFile = FileTypeUtils.computeFilenameForXamlCSharpImpl("View/Screens",
				p_oScreen.getName(), p_oMProject.getSourceDir());

		// Check whether it is a Screen layout or a layout that is being generated
		if (p_oScreen.getPageCount() == 0) {
			// Check if the target platform is Windows Store 8.1 or Windows Phone 8.1
			if (p_oMProject.getSourceDir().contains("Store")) {
				this.selectedXslTemplate = STORE_CS_LAYOUT_XSL_TEMPLATE;
			} else {
				this.selectedXslTemplate = PHONE_CS_LAYOUT_XSL_TEMPLATE;
			}
			xCSLayout = this.computeXmlForCSLayout(p_oScreen, p_oScreen.getLayout(), p_oMProject);
		} else {
			// Check if the target platform is Windows Store 8.1 or Windows Phone 8.1
			if (p_oMProject.getSourceDir().contains("Store")) {
				this.selectedXslTemplate = STORE_CS_SCREEN_XSL_TEMPLATE;
			} else {
				this.selectedXslTemplate = PHONE_CS_SCREEN_XSL_TEMPLATE;
			}
			xCSLayout = this.computeXmlForCSLayout(p_oScreen, p_oScreen, p_oMProject);
		}

		// Apply the xsl template to the xml description
		log.debug("generation du fichier {}", sCSLayoutFile);
		this.doIncrementalTransform(this.selectedXslTemplate, sCSLayoutFile,
				xCSLayout, p_oMProject, p_oContext);
	}

	/**
	 * Compute xml node of the .xaml.cs layout
	 * @param p_oScreen
	 * @param p_oElement
	 * @param p_oMProject
	 * @return
	 */
	protected Document computeXmlForCSLayout(MScreen p_oScreen, SGeneratedElement p_oElement,
	                                         XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) {

		// Get the base XML description from the generated element
		Element r_xFile = p_oElement.toXml();
		// Add the store/phone flag
		if (p_oMProject.getSourceDir().contains("Store")) {
			r_xFile.addElement("is-store").setText("true");
		} else {
			r_xFile.addElement("is-store").setText("false");
		}
		// Add the package used as the C# namespace
		r_xFile.addElement("package").setText(p_oScreen.getPackage().getFullName());
		// Add the class name
		r_xFile.addElement("screen-name").setText(p_oScreen.getName());
		if (p_oScreen.getPageCount() > 0) {
			r_xFile.addElement("page-package").setText(p_oScreen.getPages().get(0).getPackage().getFullName());
		}

		// Generate a dom4j Document
		Document xCSLayout = DocumentHelper.createDocument(r_xFile);

		// Add menus to the XML description
		Element xMenuElement = DocumentHelper.createElement("menus");
		for (MMenu menu : p_oScreen.getMenus()) {
			xMenuElement.add(menu.toXml());
		}
		xCSLayout.getRootElement().add(xMenuElement);

		// Add imports to other packages

		return xCSLayout;
	}
}