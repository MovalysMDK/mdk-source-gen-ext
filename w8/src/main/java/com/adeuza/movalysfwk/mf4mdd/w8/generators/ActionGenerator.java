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
import com.a2a.adjava.languages.w8.xmodele.MW8ImportDelegate;
import com.a2a.adjava.utils.FileTypeUtils;
import com.a2a.adjava.xmodele.MAction;
import com.a2a.adjava.xmodele.MActionInterface;
import com.a2a.adjava.xmodele.MActionType;
import com.a2a.adjava.xmodele.MPage;
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
public class ActionGenerator extends AbstractIncrementalGenerator<MFDomain<MFModelDictionary, MFModelFactory>> {

	/**
	 * Logger
	 */
	private static final Logger log = LoggerFactory.getLogger(ActionGenerator.class);

	/**
	 * Template for action implementation
	 */
	private static final String ACTION_IMPL_TEMPLATE = "action/action-impl.xsl";
	
	/**
	 * Template for action interface
	 */
	private static final String ACTION_INTERFACE_TEMPLATE = "action/action-interface.xsl";
	
	/**
	 * {@inheritDoc}
	 **/
	@Override
	public void genere(XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject, DomainGeneratorContext p_oContext)
			throws Exception {
		log.debug("> DataLoaderGenerator.genere");
//		Chrono oChrono = new Chrono(true);
		for(MActionInterface oIAction : p_oMProject.getDomain().getDictionnary().getAllActionInterfaces()) {
			if ( oIAction.getActionType().equals(MActionType.SAVEDETAIL) ||
					oIAction.getActionType().equals(MActionType.DELETEDETAIL)) {
				createActionInterface(oIAction, p_oMProject, p_oContext);
			}
		}
		for(MAction oAction : p_oMProject.getDomain().getDictionnary().getAllActions()) {
			if ( oAction.getType().equals(MActionType.SAVEDETAIL) ||
					oAction.getType().equals(MActionType.DELETEDETAIL)) {
				createAction(oAction, p_oMProject, p_oContext);
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
	private void createAction(MAction p_oAction, XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject,
			DomainGeneratorContext p_oContext) throws Exception {
		
		Element r_xFile = p_oAction.toXml();
		log.debug("  >> adding Element :<master-package>"+p_oMProject.getDomain().getRootPackage()+"</>");
		
		MF4WImportDelegate oImportDlg = new MF4WImportDelegate(this);
		
		// Cas d'une entité non transient
		if (p_oAction.getDao() != null)
		{
			oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.DAO.name(), p_oAction.getDao().getPackage().getFullName());
		}
		oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.ENTITIES.name(),p_oAction.getEntity().getPackage().getFullName());
//		oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.VIEWMODEL.name(),p_oAction.getVm().getPackage().getFullName());
		r_xFile.add(oImportDlg.toXml());
		
		Document xDoc = DocumentHelper.createDocument(r_xFile);
		
		String sFile = this.getImplFileName(p_oAction, p_oMProject);
		//String sFile = FileTypeUtils.computeFilenameForJavaClass(p_oMProject.getSourceDir(), p_oPage.getFullName());
		
		log.debug("  generation du fichier: {}", sFile);
		this.doIncrementalTransform(this.getImplTemplate(), sFile, xDoc, p_oMProject, p_oContext);
	}
	
	/**
	 * Create panel interface
	 * @param p_oScreen panel
	 * @param p_oMProject project
	 * @param p_oContext context
	 * @throws Exception
	 */
	protected void createActionInterface(MActionInterface p_oAction, XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject, 
			DomainGeneratorContext p_oContext ) throws Exception {
		
		LanguageConfiguration langConf = p_oMProject.getDomain().getLanguageConf();
		Element r_xFile = p_oAction.toXml();
		log.debug("  >> adding Element :<master-package>"+p_oMProject.getDomain().getRootPackage()+"</>");
		
		
		MF4WImportDelegate oImportDlg = new MF4WImportDelegate(this);
		r_xFile.add(oImportDlg.toXml());
		
		Document xDoc = DocumentHelper.createDocument(r_xFile);
		
		String sFile = this.getInterfaceFileName(p_oAction, p_oMProject);
		//String sFile = FileTypeUtils.computeFilenameForJavaClass(p_oMProject.getSourceDir(), p_oPage.getFullName());
		
		log.debug("  generation du fichier: {}", sFile);
		this.doIncrementalTransform(this.getInterfaceTemplate(), sFile, xDoc, p_oMProject, p_oContext);
	}
	
	
	/**
	 * Compute xml node of the action
	 * @param p_oPanel action
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
	 * Get template for panel interface
	 * @return template for panel interface
	 */
	protected String getInterfaceTemplate() {
		return ACTION_INTERFACE_TEMPLATE ;
	}
	
	/**
	 * Get template for action implementation
	 * @return template for panel implementation
	 */
	protected String getImplTemplate() {
		return ACTION_IMPL_TEMPLATE ;
	}
	
	/**
	 * Get filename for action implementation
	 * @param p_oPanel panel
	 * @param p_oMProject project
	 * @return file name for implementation
	 */
	protected String getImplFileName( MAction p_oAction, XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) {
		LanguageConfiguration langConf = p_oMProject.getDomain().getLanguageConf();
 	return FileTypeUtils.computeFilenameForCSharpImpl(
				"Application.Actions", p_oAction.getName(),p_oMProject.getSourceDir());
	}
	
	/**
	 * Get filename for action interface
	 * @param p_oPanel panel
	 * @param p_oMProject project
	 * @return file name for interface
	 */
	protected String getInterfaceFileName( MActionInterface p_oAction, XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) {
		LanguageConfiguration langConf = p_oMProject.getDomain().getLanguageConf();
		return FileTypeUtils.computeFilenameForCSharpImpl(
				"Application.Actions.Interfaces",p_oAction.getName(),p_oMProject.getSourceDir());
	}
}
