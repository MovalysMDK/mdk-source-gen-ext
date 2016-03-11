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
package com.adeuza.movalysfwk.mf4mdd.html5.generators;

import org.apache.commons.lang3.StringUtils;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.generator.core.incremental.AbstractIncrementalGenerator;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.utils.FileTypeUtils;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.MEntityInterface;
import com.a2a.adjava.xmodele.MJoinEntityImpl;
import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.html5.xmodele.MF4HDictionary;
import com.adeuza.movalysfwk.mf4mdd.html5.xmodele.MF4HDomain;
import com.adeuza.movalysfwk.mf4mdd.html5.xmodele.MF4HModelFactory;

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

public class PojoCascadeGenerator extends AbstractIncrementalGenerator<MF4HDomain<MF4HDictionary, MF4HModelFactory>> {
	
	/**
	 * 
	 */
	private static final Logger log = LoggerFactory.getLogger(PojoCascadeGenerator.class);
	
	private static final String docPath = "webapp/src/app/data/model/cascades";

	
	/**
	 * {@inheritDoc}
	 */
	@Override
	public void genere(XProject<MF4HDomain<MF4HDictionary, MF4HModelFactory>> p_oMProject, DomainGeneratorContext p_oContext) throws Exception {

		log.debug("> PojoCascadeGenerator.genere");
		Chrono oChrono = new Chrono(true);
		
		IModelDictionary oDictionnary = p_oMProject.getDomain().getDictionnary();

		for (MEntityImpl oClass : oDictionnary.getAllEntities()) {
			if (!oClass.getAssociations().isEmpty()) {
				this.createCascade(oClass.getMasterInterface(), oClass, p_oMProject, p_oContext);
			}
		}

		for (MJoinEntityImpl oJoinClass : oDictionnary.getAllJoinClasses()) {
			if (!oJoinClass.getAssociations().isEmpty()) {
				this.createCascade(oJoinClass.getMasterInterface(), oJoinClass, p_oMProject, p_oContext);
			}
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
	private void createCascade(MEntityInterface p_oInterface, MEntityImpl p_oClass, XProject<MF4HDomain<MF4HDictionary, MF4HModelFactory>> p_oProject,
			DomainGeneratorContext p_oContext) throws Exception {

		Element r_xInterfaceFile = DocumentHelper.createElement("pojo");
		r_xInterfaceFile.add(p_oClass.toXml());
		Document xInterfaceDoc = DocumentHelper.createDocument(r_xInterfaceFile);

		String sTargetFile = StringUtils.join( docPath, "/", p_oClass.getName(),"Cascade.js");

		this.doIncrementalTransform("cascade.xsl", sTargetFile, xInterfaceDoc, p_oProject, p_oContext);
	}
}
