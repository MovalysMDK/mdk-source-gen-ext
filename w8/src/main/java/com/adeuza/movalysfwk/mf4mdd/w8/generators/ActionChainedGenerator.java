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
import com.a2a.adjava.languages.w8.xmodele.MW8ImportDelegate;
import com.a2a.adjava.utils.FileTypeUtils;
import com.a2a.adjava.xmodele.MAction;
import com.a2a.adjava.xmodele.MActionInterface;
import com.a2a.adjava.xmodele.MActionType;
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
public class ActionChainedGenerator extends AbstractIncrementalGenerator<MFDomain<MFModelDictionary, MFModelFactory>> {

	/**
	 * Logger
	 */
	private static final Logger log = LoggerFactory.getLogger(ActionChainedGenerator.class);

	/**
	 * Template for action implementation
	 */
	private static final String ACTION_IMPL_TEMPLATE = "action/action-chained-impl.xsl";
	
	/**
	 * Template for action interface
	 */
	private static final String ACTION_INTERFACE_TEMPLATE = "action/action-chained-interface.xsl";
	
	/**
	 * {@inheritDoc}
	 **/
	@Override
	public void genere(XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject, DomainGeneratorContext p_oContext)
			throws Exception {
		log.debug("> DataLoaderGenerator.genere");
		int nbVMDetail = 0, nbVMDelete = 0;
		for (MScreen oMScreen : p_oMProject.getDomain().getDictionnary().getAllScreens()) {
			nbVMDetail = 0;
			nbVMDelete = 0;
			oMScreen.getPages();
			for (MPage oMPage : oMScreen.getPages()) {
				for (MAction oIAction : oMPage.getActions()) {
					if ( oIAction.getType().equals(MActionType.SAVEDETAIL)) {
						if (nbVMDetail >= 0) {
							nbVMDetail++;
							if (nbVMDetail >= 1)
							{
								createActionInterface("ISaveChained", oMScreen,oIAction.getMasterInterface(), p_oMProject, p_oContext);
								createAction("SaveChained", oMScreen,oIAction, p_oMProject, p_oContext);
								nbVMDetail = -1; 
							}
						}
					} else if ( oIAction.getType().equals(MActionType.DELETEDETAIL)) {
						if (nbVMDelete >= 0) {
							nbVMDelete++;
							if (nbVMDelete >= 1)
							{
								createActionInterface("IDeleteChained", oMScreen,oIAction.getMasterInterface(), p_oMProject, p_oContext);
								createAction("DeleteChained", oMScreen,oIAction, p_oMProject, p_oContext);
								nbVMDelete = -1;
							}
						}
					}
				}
			}
			
		}
	}

	/**
	 * Generate panel (implementation and interface) 
	 * @param p_sActionImplPrefix file name prefix
	 * @param p_oScreen panel
	 * @param p_oMProject project
	 * @param p_oContext context
	 * @throws Exception failure
	 */
	private void createAction(String p_sActionImplPrefix, MScreen oMScreen,MAction p_oAction, XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject,
			DomainGeneratorContext p_oContext) throws Exception {
		
		Element r_xFile = p_oAction.toXml();
		log.debug("  >> adding Element :<master-package>"+p_oMProject.getDomain().getRootPackage()+"</>");
		r_xFile.addElement("chained-action").setText(oMScreen.getName());			
		r_xFile.addElement("namespace-action").setText(oMScreen.getPackage().getFullName());			
		
		MF4WImportDelegate oImportDlg = new MF4WImportDelegate(this);
		// Cas d'une entité non transient
		if (p_oAction.getDao() != null)
		{
			oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.DAO.name(), p_oAction.getDao().getPackage().getFullName());
		}
		oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.ENTITIES.name(),p_oAction.getEntity().getPackage().getFullName());
		r_xFile.add(oImportDlg.toXml());
		
		Document xDoc = DocumentHelper.createDocument(r_xFile);
		
		String sFile = this.getImplFileName(p_sActionImplPrefix, oMScreen,p_oAction, p_oMProject);
		
		log.debug("  generation du fichier: {}", sFile);
		this.doIncrementalTransform(this.getImplTemplate(), sFile, xDoc, p_oMProject, p_oContext);
	}
	
	/**
	 * Create panel interface
	 * @param p_sActionItfPrefix file name prefix
	 * @param p_oScreen panel
	 * @param p_oMProject project
	 * @param p_oContext context
	 * @throws Exception
	 */
	protected void createActionInterface(String p_sActionItfPrefix, MScreen oMScreen,MActionInterface p_oAction, XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject, 
			DomainGeneratorContext p_oContext ) throws Exception {
		
		Element r_xFile = p_oAction.toXml();
		r_xFile.addElement("chained-action").setText(oMScreen.getName());			
		r_xFile.addElement("namespace-action").setText(oMScreen.getPackage().getFullName());			
		log.debug("  >> adding Element :<master-package>"+p_oMProject.getDomain().getRootPackage()+"</>");
		
		
		MF4WImportDelegate oImportDlg = new MF4WImportDelegate(this);
		r_xFile.add(oImportDlg.toXml());
		
		Document xDoc = DocumentHelper.createDocument(r_xFile);
		
		String sFile = this.getInterfaceFileName(p_sActionItfPrefix, oMScreen,p_oAction, p_oMProject);
		
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
	protected String getImplFileName( String p_sActionImplPrefix, MScreen oMScreen,MAction p_oAction, XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) {
		StringBuilder sName = new StringBuilder();
		sName.append(p_sActionImplPrefix);
		sName.append(oMScreen.getName());		
 	return FileTypeUtils.computeFilenameForCSharpImpl(
				"View.Actions",sName.toString(),p_oMProject.getSourceDir());
	}
	
	/**
	 * Get filename for action interface
	 * @param p_oPanel panel
	 * @param p_oMProject project
	 * @return file name for interface
	 */
	protected String getInterfaceFileName( String p_sActionItfPrefix, MScreen oMScreen, MActionInterface p_oAction, XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) {
		StringBuilder sName = new StringBuilder();
		sName.append(p_sActionItfPrefix);
		sName.append(oMScreen.getName());		
		return FileTypeUtils.computeFilenameForCSharpImpl(
				"View.Actions.Interfaces",sName.toString(),p_oMProject.getSourceDir());
	}
}
