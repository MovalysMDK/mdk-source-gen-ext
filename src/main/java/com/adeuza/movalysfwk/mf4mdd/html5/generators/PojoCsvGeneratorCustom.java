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

import java.io.File;
import org.apache.commons.io.FileUtils;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.MJoinEntityImpl;
import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.commons.generator.PojoCsvGenerator;

/**
 * <p>
 * 	Genere le csv correspondant au modèle afin qu'il soit importé dans le fichier d'injection de donnée.
 * </p>
 * 
 * <p>Copyright (c) 2009</p>
 * <p>Company: Adeuza</p>
 *
 * @author fbourlieux
 * @param <D>
 * @since MF-Annapurna
 */
public class PojoCsvGeneratorCustom extends PojoCsvGenerator {

	/**
	 * Logger for this class
	 */
	private static final Logger log = LoggerFactory.getLogger(PojoCsvGeneratorCustom.class);
	/**
	 * Compteur de boucles pour ordonner les classes
	 */
	private int iCompteurBoucles = 0 ;
	/**
	 * Nombre maximum de boucles pour ordonner les classes
	 */
	private static final int NB_MAX_BOUCLE = 20 ;
	/**
	 * Indice du compteur de boucles à partir duquel on tolère les associations facultatives
	 */
	private static final int INDEX_BOUCLE_WITH_NOTNULL = 10 ;
	/**
	 * {@inheritDoc}
	 */
	@Override
	public void genere(XProject p_oProject, DomainGeneratorContext p_oGeneratorContext) throws Exception {
		log.debug("> PojoCsvGenerator.genere");
		Chrono oChrono = new Chrono(true);
		
		IModelDictionary oDictionnary = p_oProject.getDomain().getDictionnary();
		
		String sPojoFile = p_oProject.getBaseDir() + "/tools/adjava-generated-model.csv";
		File oFile = new File(p_oProject.getBaseDir() + "/" + sPojoFile);
		if (oFile.exists()) {
			FileUtils.deleteQuietly(oFile);
		}
		
		Element xRoot = DocumentHelper.createElement("diagram");
		Document xDoc = DocumentHelper.createDocument(xRoot);
		if (p_oProject.getDomain().getSchema()!=null){ // schema facultatif : sur iOS le schema n'est pas généré
			xRoot.add(p_oProject.getDomain().getSchema().toXml());
		}
		
		Element xClasses = xRoot.addElement("classes"); 
		this.addOrderedClasses(xClasses, oDictionnary,null) ;
		
		for (MJoinEntityImpl oEntity : oDictionnary.getAllJoinClasses()) {
			xClasses.add(oEntity.toXml());
		}
		log.debug("  generation du fichier: {} ", sPojoFile);
		this.doTransformToFile(xDoc, "pojo-csv.xsl", sPojoFile, p_oProject, p_oGeneratorContext);

		log.debug("< PojoCsvGenerator.genere: {}", oChrono.stopAndDisplay());
	}
}
