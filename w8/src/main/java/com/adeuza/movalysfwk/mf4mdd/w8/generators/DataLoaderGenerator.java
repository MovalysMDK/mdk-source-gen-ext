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
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.utils.FileTypeUtils;
import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoader;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoaderCombo;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFDomain;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelDictionary;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelFactory;
import com.adeuza.movalysfwk.mf4mdd.w8.xmodele.MF4WImportDelegate;

/**
 * Dataloader generator
 * @author lmichenaud
 * 
 */
public class DataLoaderGenerator extends AbstractIncrementalGenerator<MFDomain<MFModelDictionary, MFModelFactory>> {

	/**
	 * Logger
	 */
	private static final Logger log = LoggerFactory.getLogger(DataLoaderGenerator.class);

	/**
	 * Template for dataloader implementation
	 */
	private static final String DATALOADER_IMPL_TEMPLATE = "dataloader/dataloader-impl.xsl";
	
	/**
	 * Template for dataloader interface
	 */
	private static final String DATALOADER_INTERFACE_TEMPLATE = "dataloader/dataloader-interface.xsl";
	
	private MF4WImportDelegate oImportDlg;
	
	/**
	 * {@inheritDoc}
	 **/
	@Override
	public void genere(XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject, DomainGeneratorContext p_oContext)
			throws Exception {
		log.debug("> DataLoaderGenerator.genere");
		Chrono oChrono = new Chrono(true);
		for (MDataLoader oMDataLoader : p_oMProject.getDomain().getDictionnary().getAllDataLoaders()) {
			this.createDataLoader(oMDataLoader, p_oMProject, p_oContext);
		}
		log.debug("< DataLoaderGenerator.genere: {}", oChrono.stopAndDisplay());
	}

	/**
	 * Generate dataloader (implementation and interface) 
	 * @param p_oDataLoader dataloader
	 * @param p_oMProject project
	 * @param p_oContext context
	 * @throws Exception failure
	 */
	private void createDataLoader(MDataLoader p_oDataLoader, XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject,
			DomainGeneratorContext p_oContext) throws Exception {
		
		oImportDlg = new MF4WImportDelegate(this);
		this.createDataLoaderInterface(p_oDataLoader, p_oMProject, p_oContext);
		this.createDataLoaderImpl(p_oDataLoader, p_oMProject, p_oContext);
	}
	
	/**
	 * Create dataloader interface
	 * @param p_oDataLoader dataloader
	 * @param p_oMProject project
	 * @param p_oContext context
	 * @throws Exception
	 */
	protected void createDataLoaderInterface( MDataLoader p_oDataLoader, XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject, 
			DomainGeneratorContext p_oContext ) throws Exception {
		
		DocumentHelper.createDocument();
		String sDataLoaderInterfaceFile = this.getInterfaceFileName(p_oDataLoader, p_oMProject);
		
		Document xDataLoaderItf = this.computeXmlForDataLoaderInterface(p_oDataLoader, p_oMProject);
		
		log.debug("  generation du fichier {}", sDataLoaderInterfaceFile);
		this.doIncrementalTransform( this.getInterfaceTemplate(), sDataLoaderInterfaceFile,
				xDataLoaderItf, p_oMProject, p_oContext);
	}
	
	/**
	 * Create dataloader impl
	 * @param p_oDataLoader dataloader
	 * @param p_oMProject project
	 * @param p_oContext context
	 * @throws Exception
	 */
	protected void createDataLoaderImpl( MDataLoader p_oDataLoader, 
			XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject, DomainGeneratorContext p_oContext ) throws Exception {
		
		String sDataLoaderImplFile = this.getImplFileName(p_oDataLoader, p_oMProject);
		
		Document xDataLoaderImpl = this.computeXmlForDataLoaderImpl(p_oDataLoader, p_oMProject);
		
		log.debug("  generation du fichier {}", sDataLoaderImplFile);
		this.doIncrementalTransform( this.getImplTemplate(), sDataLoaderImplFile, xDataLoaderImpl,
				p_oMProject, p_oContext);
	}
	
	/**
	 * Compute xml node of the dataloader
	 * @param p_oDataLoader dataloader
	 * @return xml 
	 */
	protected Document computeXmlForDataLoaderInterface( MDataLoader p_oDataLoader, XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject ) {
		Element r_xFile = p_oDataLoader.getMasterInterface().toXml();


		oImportDlg.addImport(MF4WImportDelegate.MW8ImportCategory.FACTORIES.name(), p_oDataLoader.getMasterInterface().getEntity().getPackage().getFullName());
		
		for(MDataLoaderCombo oCombo : p_oDataLoader.getMasterInterface().getCombos() )
		{
			oImportDlg.addImport(MF4WImportDelegate.MW8ImportCategory.ENTITIES.name(), oCombo.getEntityViewModel().getEntityToUpdate().getPackage().getFullName());
		}
		
		if ( !p_oDataLoader.getMasterInterface().getEntity().isTransient()) 
		{
			oImportDlg.addImport(MF4WImportDelegate.MW8ImportCategory.DAO.name(), p_oDataLoader.getMasterInterface().getEntity().getDao().getPackage().getFullName());
		}
		
		if (p_oDataLoader.getMasterInterface().getCombos() != null && p_oDataLoader.getMasterInterface().getCombos().size() > 0) {
			for (MDataLoaderCombo combo : p_oDataLoader.getMasterInterface().getCombos()) {
				if (combo.getEntityDao() != null) {
					oImportDlg.addImport(MF4WImportDelegate.MW8ImportCategory.DAO.name(), combo.getEntityDao().getPackage().getFullName());
				}
			}
		}

		r_xFile.add(oImportDlg.toXml());
		
		Document xDataLoaderImpl = DocumentHelper.createDocument(r_xFile);
		return xDataLoaderImpl ;
	}
	
	/**
	 * Compute xml node of the dataloader
	 * @param p_oDataLoader dataloader
	 * @return xml 
	 */
	protected Document computeXmlForDataLoaderImpl( MDataLoader p_oDataLoader, XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject ) {
		Element r_xFile = p_oDataLoader.toXml();

		oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.FACTORIES.name(), p_oDataLoader.getMasterInterface().getEntity().getPackage().getFullName());
		
		for(MDataLoaderCombo oCombo : p_oDataLoader.getMasterInterface().getCombos() )
		{
			oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.ENTITIES.name(), oCombo.getEntityViewModel().getEntityToUpdate().getPackage().getFullName());
		}
		
		if ( !p_oDataLoader.getMasterInterface().getEntity().isTransient()) 
		{
			oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.DAO.name(), p_oDataLoader.getMasterInterface().getEntity().getDao().getPackage().getFullName());
		}
		
		r_xFile.add(oImportDlg.toXml());
		
		Document xDataLoaderImpl = DocumentHelper.createDocument(r_xFile);
		return xDataLoaderImpl ;
	}
	
	/**
	 * Get template for dataloader interface
	 * @return template for dataloader interface
	 */
	protected String getInterfaceTemplate() {
		return DATALOADER_INTERFACE_TEMPLATE ;
	}
	
	/**
	 * Get template for dataloader implementation
	 * @return template for dataloader implementation
	 */
	protected String getImplTemplate() {
		return DATALOADER_IMPL_TEMPLATE ;
	}
	
	/**
	 * Get filename for dataloader implementation
	 * @param p_oDataLoader dataloader
	 * @param p_oMProject project
	 * @return file name for implementation
	 */
	protected String getImplFileName( MDataLoader p_oDataLoader, XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) {
		return FileTypeUtils.computeFilenameForCSharpImpl("/DataLoader", p_oDataLoader.getName(), p_oMProject.getSourceDir());
	}
	
	/**
	 * Get filename for dataloader interface
	 * @param p_oDataLoader dataloader
	 * @param p_oMProject project
	 * @return file name for interface
	 */
	protected String getInterfaceFileName( MDataLoader p_oDataLoader, XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) {
		return FileTypeUtils.computeFilenameForCSharpInterface("/DataLoader/Interfaces", p_oDataLoader.getMasterInterface().getName(), p_oMProject.getSourceDir());
	}
}
