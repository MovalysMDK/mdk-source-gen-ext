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
package com.adeuza.movalysfwk.mf4mdd.ios.generators;

import java.util.List;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.generator.core.incremental.AbstractIncrementalGenerator;
import com.a2a.adjava.generator.core.incremental.NonGeneratedBlocExtractor;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.languages.ios.xmodele.MIOSImportDelegate;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.utils.FileTypeUtils;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MDialog;
import com.a2a.adjava.xmodele.MPage;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.MViewModelCreator;
import com.a2a.adjava.xmodele.MViewModelImpl;
import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFViewModel;
import com.adeuza.movalysfwk.mf4mdd.ios.xmodele.MF4IImportDelegate;

/**
 * ViewmodelCreator generator
 * @author lmichenaud
 *
 */
public class MF4IViewModelCreatorGenerator extends AbstractIncrementalGenerator<IDomain<IModelDictionary,IModelFactory>> {

	/**
	 * Logger
	 */
	private static final Logger log = LoggerFactory.getLogger(MF4IViewModelCreatorGenerator.class);
	
	/**
	 * Package of viewmodel creator
	 */
	private static final String VIEWMODELCREATOR_PACKAGE = "viewmodel";
	
	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.generators.ResourceGenerator#genere(com.a2a.adjava.xmodele.XProject, com.a2a.adjava.generators.DomainGeneratorContext)
	 */
	@Override
	public void genere(XProject<IDomain<IModelDictionary,IModelFactory>> p_oProject, DomainGeneratorContext p_oContext) throws Exception {
		log.debug("> ViewModelCreatorGenerator.genere");
		Chrono oChrono = new Chrono(true);
		NonGeneratedBlocExtractor oNonGeneratedBlocExtractor = new NonGeneratedBlocExtractor();
		
		this.createViewModelCreator(oNonGeneratedBlocExtractor, p_oProject, p_oContext);
		log.debug("< ViewModelCreatorGenerator.genere: {}", oChrono.stopAndDisplay());
	}
	
	/**
	 * Generation of the viewmodel creator
	 * @param p_oNonGeneratedBlocExtractor bloc extractor
	 * @param p_oProject project
	 * @param p_oContext context
	 * @throws Exception
	 */
	private void createViewModelCreator(NonGeneratedBlocExtractor p_oNonGeneratedBlocExtractor,
			XProject<IDomain<IModelDictionary,IModelFactory>> p_oProject, DomainGeneratorContext p_oContext) throws Exception {
		MViewModelCreator oVmc = p_oProject.getDomain().getDictionnary().getViewModelCreator();
		if (oVmc != null) {			
			this.createVmcInterface( oVmc, p_oProject, p_oContext);
			this.createVmcImpl( oVmc, p_oProject, p_oContext);
		}
	}
	
	/**
	 * Create interface of viewmodel creator
	 * @param p_oVmc viewmodel creator
	 */
	private void createVmcInterface( MViewModelCreator p_oVmc, XProject<IDomain<IModelDictionary,IModelFactory>> p_oProject, DomainGeneratorContext p_oContext ) throws Exception {
		
		Element r_xViewModelFile = DocumentHelper.createElement("master-viewmodelcreator");

		r_xViewModelFile.add(p_oVmc.toXml());
		Document xViewModelDoc = DocumentHelper.createDocument(r_xViewModelFile);
		
		Element rootElement = xViewModelDoc.getRootElement();
		rootElement.addAttribute("main-project", p_oProject.getDomain().getGlobalParameters().get("mainProject"));
		
		r_xViewModelFile.add( this.computeVmcInterfaceImports(p_oVmc));
		
		String sViewModelCreatorInterfaceFile = FileTypeUtils.computeFilenameForIOSInterface(VIEWMODELCREATOR_PACKAGE, p_oVmc.getName(),p_oProject.getSourceDir());
		log.debug("  generation du fichier {}", sViewModelCreatorInterfaceFile);
		this.doIncrementalTransform("viewmodelcreator-interface.xsl", sViewModelCreatorInterfaceFile, xViewModelDoc, p_oProject, p_oContext);		
	}
	
	/**
	 * Create implementation of viewmodel creator
	 * @param p_oVmc viewmodel creator
	 * @param p_oProject project
	 * @param p_oContext context
	 * @throws Exception
	 */
	private void createVmcImpl( MViewModelCreator p_oVmc, XProject<IDomain<IModelDictionary,IModelFactory>> p_oProject, DomainGeneratorContext p_oContext ) throws Exception {
		
		Element r_xViewModelFile = DocumentHelper.createElement("master-viewmodelcreator");		
		r_xViewModelFile.add(p_oVmc.toXml());
		Document xViewModelDoc = DocumentHelper.createDocument(r_xViewModelFile);
		
		Element rootElement = xViewModelDoc.getRootElement();
		rootElement.addAttribute("main-project", p_oProject.getDomain().getGlobalParameters().get("mainProject"));
		
		r_xViewModelFile.add( this.computeVmcImplImports(p_oVmc));
		
		String sViewModelCreatorImplFile = FileTypeUtils.computeFilenameForIOSImpl(VIEWMODELCREATOR_PACKAGE, p_oVmc.getName(), p_oProject.getSourceDir());
		log.debug("  generation du fichier {}", sViewModelCreatorImplFile);
		this.doIncrementalTransform("viewmodelcreator-impl.xsl", sViewModelCreatorImplFile, xViewModelDoc, p_oProject, p_oContext);		
	}
	
	
	/**
	 * Compute imports for interface of viewmodel creator
	 * @param p_oViewModelCreator viewmodel creator
	 * @return imports
	 */
	private Element computeVmcInterfaceImports( MViewModelCreator p_oViewModelCreator ) {
		MF4IImportDelegate oImportDlg = new MF4IImportDelegate(this);
		
		for( MScreen oScreen : p_oViewModelCreator.getScreens()) {
			if ( oScreen.getViewModel() != null ) {
				oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.VIEWMODEL.name(), oScreen.getViewModel().getName());	
				
				MFViewModel oVm = (MFViewModel) oScreen.getViewModel();
				if ( oVm.getDataLoader() != null ) {
					oImportDlg.addImport(MF4IImportDelegate.MF4IImportCategory.DATALOADER.name(), oVm.getDataLoader().getName());	
				}
			}
			
			for( MPage oPage : oScreen.getPages()) {
				
				MFViewModel oVm = (MFViewModel) oPage.getViewModelImpl();
				if ( oVm != null ) {
					oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.VIEWMODEL.name(), oVm.getName());
					
					if ( oVm.getDataLoader() != null ) {
						oImportDlg.addImport(MF4IImportDelegate.MF4IImportCategory.DATALOADER.name(), oVm.getDataLoader().getName());	
					}
					

					for(MViewModelImpl oExtVM : oVm.getExternalViewModels())
					{
						oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.VIEWMODEL.name(), oExtVM.getName());
					}
						
						
					
					for( MViewModelImpl oSubVm : oVm.getSubViewModels()) {
						oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.VIEWMODEL.name(), oSubVm.getName());	
					}
					
					List<MDialog> dialogs = oPage.getDialogs();
					if (dialogs.size() > 0) {
						MPage dialogPage = dialogs.get(0);
						MFViewModel dialogVm = (MFViewModel) dialogPage.getViewModelImpl();
						oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.VIEWMODEL.name(), dialogVm.getName());
						
						if ( dialogVm.getDataLoader() != null ) {
							oImportDlg.addImport(MF4IImportDelegate.MF4IImportCategory.DATALOADER.name(), dialogVm.getDataLoader().getName());	
						}
					}	
				}
			}
		}
		
		return oImportDlg.toXml();
	}
	
	/**
	 * Compute imports for implementation of viewmodel creator
	 * @param p_oViewModelCreator viewmodel creator
	 * @return imports
	 */
	private Element computeVmcImplImports( MViewModelCreator p_oViewModelCreator ) {
		MF4IImportDelegate oImportDlg = new MF4IImportDelegate(this);
		oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.VIEWMODEL.name(), p_oViewModelCreator.getName());	
		return oImportDlg.toXml();
	}
}
