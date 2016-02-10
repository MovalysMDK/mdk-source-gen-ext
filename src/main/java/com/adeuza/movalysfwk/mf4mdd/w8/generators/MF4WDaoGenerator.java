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
import com.a2a.adjava.languages.w8.xmodele.MW8Dictionary;
import com.a2a.adjava.languages.w8.xmodele.MW8Domain;
import com.a2a.adjava.languages.w8.xmodele.MW8ImportDelegate;
import com.a2a.adjava.languages.w8.xmodele.MW8ModeleFactory;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.utils.FileTypeUtils;
import com.a2a.adjava.xmodele.MAssociation;
import com.a2a.adjava.xmodele.MDaoImpl;
import com.a2a.adjava.xmodele.MDaoInterface;
import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.w8.xmodele.MF4WImportDelegate;

/**
 * Generator of dao implementation
 * @author sbernardin
 *
 */
public class MF4WDaoGenerator extends AbstractIncrementalGenerator<MW8Domain<MW8Dictionary, MW8ModeleFactory>> {

	/**
	 * Logger for this class
	 */
	private static final Logger log = LoggerFactory.getLogger(MF4WDaoGenerator.class);

	/**
	 * Dao partial prefix
	 */
	private static final String PARTIAL_PREFIX = "Partial";
	
	/**
	 * Template for dao impl xsl
	 */
	private static final String DAO_XSL = "dao.xsl";
	
	/**
	 * Template for dao partial xsl
	 */
	private static final String DAO_PARTIAL_XSL = "dao-partial.xsl";

	/**
	 * Template for dao interface xsl
	 */
	private static final String DAO_ITF_XSL = "dao-interface.xsl";
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	public void genere(XProject<MW8Domain<MW8Dictionary, MW8ModeleFactory>> p_oProject, DomainGeneratorContext p_oContext) throws Exception {
		log.debug("> DaoGenerator.genere");
		Chrono oChrono = new Chrono(true);

		for (MDaoImpl oDao : p_oProject.getDomain().getDictionnary().getAllDaos()) {
			createDao(oDao, p_oProject, p_oContext );
			createDaoPartial(oDao, p_oProject, p_oContext );
			createDaoInterface(oDao.getMasterInterface(), p_oProject, p_oContext );
		}

		log.debug("< DaoGenerator.genere: {}", oChrono.stopAndDisplay());
	}
	
	/**
	 * Genere dao implementation
	 * @param p_oDao dao
	 * @param p_oNonGeneratedBlocExtractor extractor of non-generated blocs
	 * @param p_oProject project
	 * @param p_oContext context
	 * @throws Exception exception
	 */
	private void createDao(MDaoImpl p_oDao, XProject<MW8Domain<MW8Dictionary, MW8ModeleFactory>> p_oProject, DomainGeneratorContext p_oContext) throws Exception {

		Document xDaoDoc = DocumentHelper.createDocument(p_oDao.toXml());
		
		xDaoDoc.getRootElement().add(this.computeImports(p_oDao));
		
		String sDaoFile = FileTypeUtils.computeFilenameForCSharpImpl("Dao", p_oDao.getName(), p_oProject.getSourceDir());

		log.debug("  generating file {}", sDaoFile);
		this.doIncrementalTransform(DAO_XSL, sDaoFile, xDaoDoc, p_oProject, p_oContext);
	}
	
	/**
	 * Genere dao partial implementation
	 * @param p_oMDaoInterface dao interface
	 * @param p_oNonGeneratedBlocExtractor extractor of non-generated blocs
	 * @param p_oProject project
	 * @param p_oContext context
	 * @throws Exception exception
	 */
	private void createDaoPartial(MDaoImpl p_oDao, XProject<MW8Domain<MW8Dictionary, MW8ModeleFactory>> p_oProject, DomainGeneratorContext p_oContext) throws Exception {

		Document xDaoDoc = DocumentHelper.createDocument(p_oDao.toXml());
		
		xDaoDoc.getRootElement().add(this.computeImports(p_oDao));
		
		String fileName = PARTIAL_PREFIX + p_oDao.getName(); // we add Partial prefix to the file's name
		
		String sDaoInterfaceFile = FileTypeUtils.computeFilenameForCSharpImpl("Dao/Partials", fileName, p_oProject.getSourceDir());

		log.debug("  generating file {}", sDaoInterfaceFile);
		this.doIncrementalTransform(DAO_PARTIAL_XSL, sDaoInterfaceFile, xDaoDoc, p_oProject, p_oContext);
	}
	
	/**
	 * Genere dao implementation
	 * @param p_oDao dao
	 * @param p_oNonGeneratedBlocExtractor extractor of non-generated blocs
	 * @param p_oProject project
	 * @param p_oContext context
	 * @throws Exception exception
	 */
	private void createDaoInterface(MDaoInterface p_oDaoInterface, XProject<MW8Domain<MW8Dictionary, MW8ModeleFactory>> p_oProject, DomainGeneratorContext p_oContext) throws Exception {

		Document xDaoDoc = DocumentHelper.createDocument(p_oDaoInterface.toXml());
		
		xDaoDoc.getRootElement().add(this.computeInterfaceImports(p_oDaoInterface));
		
		String sDaoFile = FileTypeUtils.computeFilenameForCSharpImpl("Dao/Interfaces", p_oDaoInterface.getName(), p_oProject.getSourceDir());

		log.debug("  generating file {}", sDaoFile);
		this.doIncrementalTransform(DAO_ITF_XSL, sDaoFile, xDaoDoc, p_oProject, p_oContext);
	}
	
	/**
	 * Compute imports for dao
	 * @param p_oDao dao
	 * @return xml of imports
	 */
	public Element computeImports( MDaoImpl p_oDao) {
		MF4WImportDelegate oImportDlg = new MF4WImportDelegate(this);
		oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.ENTITIES.name(), p_oDao.getMEntityImpl().getPackage().getFullName());
		if(p_oDao.getMEntityImpl().getAssociations() != null && p_oDao.getMEntityImpl().getAssociations().size() > 0){
			for(MAssociation oAssosiation : p_oDao.getMEntityImpl().getAssociations()){
				if(oAssosiation.getRefClass() != null){
					oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.ENTITIES.name(), oAssosiation.getRefClass().getPackage().getFullName());
					if(oAssosiation.getRefClass().getDao() != null){
						oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.DAO.name(), oAssosiation.getRefClass().getDao().getPackage().getFullName());
					}
				}
			}
		}
		
		return oImportDlg.toXml();
	}
	
	/**
	 * Compute imports for dao interface
	 * @param p_oDao dao
	 * @return xml of imports
	 */
	public Element computeInterfaceImports( MDaoInterface p_oDao) {
		MF4WImportDelegate oImportDlg = new MF4WImportDelegate(this);
		oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.ENTITIES.name(), p_oDao.getMEntityImpl().getPackage().getFullName());
		if(p_oDao.getMEntityImpl().getAssociations() != null && p_oDao.getMEntityImpl().getAssociations().size() > 0){
			for(MAssociation oAssosiation : p_oDao.getMEntityImpl().getAssociations()){
				if(oAssosiation.getRefClass() != null){
					oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.ENTITIES.name(), oAssosiation.getRefClass().getPackage().getFullName());
					if(oAssosiation.getRefClass().getDao() != null){
						oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.DAO.name(), oAssosiation.getRefClass().getDao().getPackage().getFullName());
					}
				}
			}
		}
		return oImportDlg.toXml();
	}
}
