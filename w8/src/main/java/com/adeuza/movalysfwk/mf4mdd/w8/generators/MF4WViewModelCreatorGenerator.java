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
import com.a2a.adjava.generator.core.incremental.NonGeneratedBlocExtractor;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.languages.w8.xmodele.MW8ImportDelegate;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.utils.FileTypeUtils;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.MViewModelCreator;
import com.a2a.adjava.xmodele.MViewModelImpl;
import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoader;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFViewModel;
import com.adeuza.movalysfwk.mf4mdd.w8.xmodele.MF4WImportDelegate;


/**
 * ViewmodelCreator generator
 * @author lmichenaud
 *
 */
public class MF4WViewModelCreatorGenerator extends AbstractIncrementalGenerator<IDomain<IModelDictionary,IModelFactory>> {

	/**
	 * Logger
	 */
	private static final Logger log = LoggerFactory.getLogger(MF4WViewModelCreatorGenerator.class);
	
	/**
	 * Package of viewmodel creator
	 */
	private static final String VIEWMODELCREATOR_PACKAGE = "Viewmodel";
	
	/**
	 * Package of interface viewmodel creator
	 */
	private static final String VIEWMODELCREATORINTERFACE_PACKAGE = "Viewmodel/Interfaces";

	
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
		
		MF4WImportDelegate oImportDlg = new MF4WImportDelegate(this);
		for (MEntityImpl oEntitie : p_oProject.getDomain().getDictionnary().getAllEntities())
		{
			oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.ENTITIES.name(), oEntitie.getPackage().getFullName());
		}
		
		for (MViewModelImpl oViewModel : p_oProject.getDomain().getDictionnary().getAllViewModels())
		{
			oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.VIEWMODEL.name(), oViewModel.getPackage().getFullName());
			MDataLoader oDataLoader = ((MFViewModel)oViewModel).getDataLoader();
			if(oDataLoader != null){
				oImportDlg.addImport(MF4WImportDelegate.MF4WImportCategory.DATALOADER.name(), oDataLoader.getPackage().getFullName());
			}
		}
		
		xViewModelDoc.getRootElement().add(oImportDlg.toXml());
		
		String sViewModelCreatorInterfaceFile = FileTypeUtils.computeFilenameForCSharpImpl(VIEWMODELCREATORINTERFACE_PACKAGE, p_oProject.getDomain().getLanguageConf().getInterfaceNamingPrefix()+p_oVmc.getName(),p_oProject.getSourceDir());
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
		
		MF4WImportDelegate oImportDlg = new MF4WImportDelegate(this);
		for (MEntityImpl oEntitie : p_oProject.getDomain().getDictionnary().getAllEntities())
		{
			oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.ENTITIES.name(), oEntitie.getPackage().getFullName());
		}
		
		for (MViewModelImpl oViewModel : p_oProject.getDomain().getDictionnary().getAllViewModels())
		{
			oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.VIEWMODEL.name(), oViewModel.getPackage().getFullName());
			MDataLoader oDataLoader = ((MFViewModel)oViewModel).getDataLoader();
			if(oDataLoader != null){
				oImportDlg.addImport(MF4WImportDelegate.MF4WImportCategory.DATALOADER.name(), oDataLoader.getPackage().getFullName());
			}
		}
		xViewModelDoc.getRootElement().add(oImportDlg.toXml());
		
		
		String sViewModelCreatorImplFile = FileTypeUtils.computeFilenameForCSharpImpl(VIEWMODELCREATOR_PACKAGE, p_oVmc.getName(), p_oProject.getSourceDir());
		log.debug("  generation du fichier {}", sViewModelCreatorImplFile);
		this.doIncrementalTransform("viewmodelcreator-impl.xsl", sViewModelCreatorImplFile, xViewModelDoc, p_oProject, p_oContext);		
	}

}
