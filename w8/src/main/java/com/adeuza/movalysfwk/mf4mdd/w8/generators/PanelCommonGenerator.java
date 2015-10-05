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
import com.a2a.adjava.uml2xmodele.extractors.viewmodel.VMNamingHelper;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.utils.FileTypeUtils;
import com.a2a.adjava.xmodele.MAction;
import com.a2a.adjava.xmodele.MActionType;
import com.a2a.adjava.xmodele.MDialog;
import com.a2a.adjava.xmodele.MPage;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFDomain;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelDictionary;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelFactory;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFViewModel;
import com.adeuza.movalysfwk.mf4mdd.w8.xmodele.MF4WImportDelegate;
import com.adeuza.movalysfwk.mf4mdd.w8.xmodele.MF4WPage;

/**
 * Panel generator
 * @author smorat
 * 
 */
public class PanelCommonGenerator extends AbstractIncrementalGenerator<MFDomain<MFModelDictionary, MFModelFactory>> {

	/**
	 * Logger
	 */
	private static final Logger log = LoggerFactory.getLogger(PanelCommonGenerator.class);

	/**
	 * Template for panel implementation
	 */
	private static final String PANEL_COMMON_IMPL_TEMPLATE = "view/panel-common-impl.xsl";
	
	/**
	 * {@inheritDoc}
	 **/
	@Override
	public void genere(XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject, DomainGeneratorContext p_oContext)
			throws Exception {
		log.debug("> DataLoaderGenerator.genere");
		Chrono oChrono = new Chrono(true);
		
		boolean hasChainedSave, hasChainedDelete;
		
		for(MScreen oScreen : p_oMProject.getDomain().getDictionnary().getAllScreens()) {
			hasChainedSave = false;
			hasChainedDelete = false;
			for (MPage oMPage : oScreen.getPages()) {
				for (MAction oIAction : oMPage.getActions()) {
					if ( oIAction.getType().equals(MActionType.SAVEDETAIL)) {						
						hasChainedSave = true;
					} else if ( oIAction.getType().equals(MActionType.DELETEDETAIL)) {
						hasChainedDelete = true;
					}
				}
			}
			for (MPage oPage : oScreen.getPages()) {
				((MF4WPage)oPage).setHasChainedSaveAction(hasChainedSave);
				((MF4WPage)oPage).setHasChainedDeleteAction(hasChainedDelete);
				this.createPanel(oPage, oScreen, p_oMProject, p_oContext);
			}			
		}
		for(MDialog oDialog : p_oMProject.getDomain().getDictionnary().getAllDialogs()) {
			this.createPanel(oDialog, oDialog.getParent(), p_oMProject, p_oContext);
		}
		log.debug("< DataLoaderGenerator.genere: {}", oChrono.stopAndDisplay());
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

		r_xFile.addElement("section-interface").setText(VMNamingHelper.getInstance().computeSectionInterfaceName(p_oPage.getName(),false,langConf));
		r_xFile.addElement("section-implementation").setText(VMNamingHelper.getInstance().computeSectionImplementationName(p_oPage.getName(),false,langConf));
		r_xFile.addElement("master-package").setText(p_oScreen.getPackage().getFullName());
		if (p_oPage.getViewModelImpl() != null && p_oPage.getViewModelImpl().getFirstParent() != null) {
			r_xFile.addElement("parent-viewmodel").setText(p_oPage.getViewModelImpl().getFirstParent().getName());
		}
		if (p_oPage.getViewModelImpl() != null && ((MFViewModel)p_oPage.getViewModelImpl()).getDataLoader() != null) {
			r_xFile.element("viewmodel").element("dataloader-impl").addElement("dataloader-name").setText(VMNamingHelper.getInstance().computeDataloaderImplementationName(p_oPage.getName(),false,langConf));
		}
		MF4WImportDelegate oImportDlg = new MF4WImportDelegate(this);
		oImportDlg.addImport(MF4WImportDelegate.MW8ImportCategory.VIEWMODEL.name(), p_oPage.getViewModelImpl().getPackage().getFullName());
		oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.VIEWMODEL.name(), p_oMProject.getDomain().getDictionnary().getViewModelCreator().getPackage().getFullName());
		
		for(MAction action : p_oPage.getActions() )
		{
			oImportDlg.addImport(MF4WImportDelegate.MW8ImportCategory.ACTION.name(), action.getPackage().getFullName());
		}
		
		if (p_oPage.getViewModelImpl() != null && ((MFViewModel)p_oPage.getViewModelImpl()).getDataLoader() != null) {
			oImportDlg.addImport(MF4WImportDelegate.MF4WImportCategory.DATALOADER.name(),((MFViewModel)p_oPage.getViewModelImpl()).getDataLoader().getPackage().getFullName());
		}
		r_xFile.add(oImportDlg.toXml());
		
		Document xDoc = DocumentHelper.createDocument(r_xFile);
		
		String sFile = this.getImplFileName(p_oPage, p_oMProject);
		
		log.debug("  generation du fichier: {}", sFile);
		this.doIncrementalTransform(PANEL_COMMON_IMPL_TEMPLATE, sFile, xDoc, p_oMProject, p_oContext);
	}
	
	/**
	 * Get filename for panel implementation
	 * @param p_oPanel panel
	 * @param p_oMProject project
	 * @return file name for implementation
	 */
	protected String getImplFileName( MPage p_oPanel, XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) {
		LanguageConfiguration langConf = p_oMProject.getDomain().getLanguageConf();
 	return FileTypeUtils.computeFilenameForXamlCSharpImpl(
				"View.panels", VMNamingHelper.getInstance().computeSectionImplementationName(p_oPanel.getName(),false,langConf),p_oMProject.getSourceDir());
	}
}
