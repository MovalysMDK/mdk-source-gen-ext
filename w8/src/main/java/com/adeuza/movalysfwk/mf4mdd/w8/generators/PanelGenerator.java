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
import com.a2a.adjava.languages.LanguageConfiguration;
import com.a2a.adjava.uml2xmodele.extractors.viewmodel.VMNamingHelper;
import com.a2a.adjava.utils.FileTypeUtils;
import com.a2a.adjava.xmodele.MAction;
import com.a2a.adjava.xmodele.MPage;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFDomain;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelDictionary;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelFactory;
import com.adeuza.movalysfwk.mf4mdd.w8.xmodele.MF4WImportDelegate;

/**
 * Panel generator
 * @author smorat
 * 
 */
public class PanelGenerator extends AbstractIncrementalGenerator<MFDomain<MFModelDictionary, MFModelFactory>> {

	/**
	 * Logger
	 */
	private static final Logger log = LoggerFactory.getLogger(PanelGenerator.class);

	/**
	 * Template for panel implementation
	 */
	private static final String STORE_PANEL_IMPL_TEMPLATE = "view/panel-common-impl";

	/**
	 * {@inheritDoc}
	 **/
	@Override
	public void genere(XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject, DomainGeneratorContext p_oContext)
			throws Exception {
		log.debug("> DataLoaderGenerator.genere");
		for(MScreen oScreen : p_oMProject.getDomain().getDictionnary().getAllScreens()) {
			for (MPage oPage : oScreen.getPages()) {
				this.createPanel(oPage, oScreen, p_oMProject, p_oContext);
			}
		}
	}

	/**
	 * Generate panel (implementation and interface) 
	 * @param p_oScreen panel
	 * @param p_oMProject project
	 * @param p_oContext context
	 * @throws Exception failure
	 */
	private void createPanel(MPage p_oPage, MScreen p_oScreen, XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject,
			DomainGeneratorContext p_oContext) throws Exception {
		
			LanguageConfiguration langConf = p_oMProject.getDomain().getLanguageConf();
			Element r_xFile = p_oPage.toXml();
			log.debug("  >> adding Element :<master-package>"+p_oMProject.getDomain().getRootPackage()+"</>");
			
			//Document xDoc = this.computeXmlForPanelImpl(p_oPage);
			r_xFile.addElement("section-interface").setText(VMNamingHelper.getInstance().computeSectionInterfaceName(p_oPage.getName(),false,langConf));
			
			MF4WImportDelegate oImportDlg = new MF4WImportDelegate(this);
			oImportDlg.addImport(MF4WImportDelegate.MW8ImportCategory.VIEWMODEL.name(), p_oPage.getViewModelImpl().getPackage().getFullName());
			
			for(MAction action : p_oPage.getActions() )
			{
				oImportDlg.addImport(MF4WImportDelegate.MW8ImportCategory.ACTION.name(), action.getPackage().getFullName());
			}
			
			oImportDlg.addImport(MF4WImportDelegate.MF4WImportCategory.UI.name(), p_oScreen.getPackage().getFullName());
	
			r_xFile.add(oImportDlg.toXml());
			Document xDoc = DocumentHelper.createDocument(r_xFile);
			
			String sFile = this.getImplFileName(p_oPage, p_oMProject);
			
			log.debug("  generation du fichier: {}", sFile);
			this.doIncrementalTransform(this.getStoreImplTemplate(p_oMProject), sFile, xDoc, p_oMProject, p_oContext);
		}
	
	/**
	 * Create panel impl
	 * @param p_oScreen panel
	 * @param p_oMProject project
	 * @param p_oContext context
	 * @throws Exception
	 */
	protected void createPanelImpl( MPage p_oScreen, 
			XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject, DomainGeneratorContext p_oContext ) throws Exception {
		
		String sPanelImplFile = this.getImplFileName(p_oScreen, p_oMProject);
		
		Document xPanelImpl = this.computeXmlForPanelImpl(p_oScreen);
		
		log.debug("  generation du fichier {}", sPanelImplFile);
		this.doIncrementalTransform( this.getStoreImplTemplate(p_oMProject), sPanelImplFile, xPanelImpl,
				p_oMProject, p_oContext);
	}
	
	/**
	 * Compute xml node of the panel
	 * @param p_oPanel panel
	 * @return xml 
	 */
	protected Document computeXmlForPanelInterface( MPage p_oPanel ) {
		Document p_oPanelInt = DocumentHelper.createDocument(p_oPanel.getMasterInterface().toXml());
		return p_oPanelInt ;
	}
	
	/**
	 * Compute xml node of the panel
	 * @param p_oPanel panel
	 * @return xml 
	 */
	protected Document computeXmlForPanelImpl( MPage p_oPanel ) {
		Document xPanelImpl = DocumentHelper.createDocument(p_oPanel.toXml());
		return xPanelImpl ;
	}
	
	/**
	 * Get template for panel implementation
	 * @return template for panel implementation
	 */
	protected String getStoreImplTemplate(XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) {
		return STORE_PANEL_IMPL_TEMPLATE  + ".xsl";
	}

	/**
	 * Get filename for panel implementation
	 * @param p_oPanel panel
	 * @param p_oMProject project
	 * @return file name for implementation
	 */
	protected String getImplFileName( MPage p_oPanel, XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) {
		return FileTypeUtils.computeFilenameForXamlCSharpImpl(
				"View.Panels", p_oPanel.getName(),p_oMProject.getSourceDir());
	}
	
	/**
	 * Get filename for panel interface
	 * @param p_oPanel panel
	 * @param p_oMProject project
	 * @return file name for interface
	 */
	protected String getInterfaceFileName( MPage p_oPanel, XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) {
		return FileTypeUtils.computeFilenameForXamlCSharpImpl(
				"View.Panels", p_oPanel.getName(),p_oMProject.getSourceDir());
	}
}
