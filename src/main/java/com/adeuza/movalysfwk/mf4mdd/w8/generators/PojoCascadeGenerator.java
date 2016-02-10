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
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MAssociation;
import com.a2a.adjava.xmodele.MDaoImpl;
import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.MEntityInterface;
import com.a2a.adjava.xmodele.MJoinEntityImpl;
import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.w8.xmodele.MF4WImportDelegate;

/**
 * <p>
 * Genere Pojo Cascade class
 * </p>
 * 
 * <p>
 * Copyright (c) 2011
 * <p>
 * Company: Adeuza
 * 
 * @author emalespine
 * 
 */

public class PojoCascadeGenerator extends AbstractIncrementalGenerator<IDomain<IModelDictionary,IModelFactory>> {
	
	/**
	 * Logger for this class
	 */
	private static final Logger log = LoggerFactory.getLogger(PojoCascadeGenerator.class);
	
	/**
	 * Xsl template for Entity protocol 
	 */
	private static final String ENTITY_CASCADE_XSL = "entity-cascade.xsl";
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	public void genere(XProject<IDomain<IModelDictionary,IModelFactory>> p_oMProject, DomainGeneratorContext p_oContext) throws Exception {

		log.debug("> PojoCascadeGenerator.genere");
		Chrono oChrono = new Chrono(true);
		
		IModelDictionary oDictionnary = p_oMProject.getDomain().getDictionnary();

		for (MEntityImpl oClass : oDictionnary.getAllEntities()) {
			this.createCascade(oClass.getMasterInterface(), oClass, p_oMProject, p_oContext);
		}

		for (MJoinEntityImpl oJoinClass : oDictionnary.getAllJoinClasses()) {
			this.createCascade(oJoinClass.getMasterInterface(), oJoinClass, p_oMProject, p_oContext);
		}
		
		log.debug("< PojoCascadeGenerator.genere: {}", oChrono.stopAndDisplay());
	}

	/**
	 * 
	 * Génère le fichier java correspondant à l'énumération des cascades d'un type d'objet particulier
	 * 
	 * @param p_oInterface
	 *            l'interface
	 * @param p_oClass
	 *            l'implémentation de l'interface
	 * @param p_oNonGeneratedBlocExtractor
	 *            les blocs non générés
	 * @param p_oProjectConfig
	 *            config adjava
	 * @param p_oXslInterfaceTransformer
	 *            le transformer xsl
	 * @throws Exception
	 *             échec de la génération
	 */
	private void createCascade(MEntityInterface p_oInterface, MEntityImpl p_oClass, XProject<IDomain<IModelDictionary,IModelFactory>> p_oProject,
			DomainGeneratorContext p_oContext) throws Exception {

		Element r_xInterfaceFile = DocumentHelper.createElement("pojo");
		r_xInterfaceFile.add(p_oInterface.toXml());
		r_xInterfaceFile.addAttribute("main-project", p_oProject.getDomain().getGlobalParameters().get("mainProject"));
		r_xInterfaceFile.add(p_oClass.toXml());
		Document xInterfaceDoc = DocumentHelper.createDocument(r_xInterfaceFile);
		
		xInterfaceDoc.getRootElement().add(this.computeImports(p_oClass));
		
		String sBaseName = p_oClass.getName().concat("Cascade");
		
		String sInterfaceFile = FileTypeUtils.computeFilenameForCSharpImpl(
				"Model.Cascades", sBaseName, p_oProject.getSourceDir());

//		String sInterfaceFile = StringUtils.join( p_oProject.getSourceDir(), "/", p_oInterface.getFullName().replace('.', '/'),
//				"Cascade.java");

		this.doIncrementalTransform(ENTITY_CASCADE_XSL, sInterfaceFile, xInterfaceDoc, p_oProject, p_oContext);
	}
	
	/**
	 * Compute imports for entity
	 * @param p_oClass entity
	 * @return xml of imports
	 */
	public Element computeImports( MEntityImpl p_oClass) {
		MF4WImportDelegate oImportDlg = new MF4WImportDelegate(this);
		if(p_oClass.getAssociations() != null && p_oClass.getAssociations().size() > 0){
			for(MAssociation oAssosiation : p_oClass.getAssociations()){
				if(oAssosiation.getRefClass() != null){
					oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.ENTITIES.name(), oAssosiation.getRefClass().getPackage().getFullName());
				}
			}
		}
		
		return oImportDlg.toXml();
	}
}
