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
package com.adeuza.movalysfwk.mf4mdd.mbandroid.generator;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.generator.core.incremental.AbstractIncrementalGenerator;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.xmodele.MDaoImpl;
import com.a2a.adjava.xmodele.MDaoInterface;
import com.a2a.adjava.xmodele.ModelDictionary;
import com.a2a.adjava.xmodele.XDomain;
import com.a2a.adjava.xmodele.XModeleFactory;
import com.a2a.adjava.xmodele.XProject;

/**
 * <p>
 * Generate enumeration of dao fields
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

public class DaoFieldEnumGenerator extends AbstractIncrementalGenerator<XDomain<ModelDictionary, XModeleFactory>> {

	/**
	 * 
	 */
	private static final Logger log = LoggerFactory.getLogger(DaoFieldEnumGenerator.class);
	
	/**
	 * (non-Javadoc)
	 * 
	 * @see com.a2a.adjava.generator.ResourceGenerator#genere(com.a2a.adjava.project.ProjectConfig, com.a2a.adjava.xmodele.MModele,
	 *      com.a2a.adjava.schema.Schema, java.util.Map)
	 */
	public void genere(XProject<XDomain<ModelDictionary, XModeleFactory>> p_oProjectConfig, DomainGeneratorContext p_oContext) throws Exception {
		log.debug("> ActionPropertiesGenerator.genere");
		Chrono oChrono = new Chrono(true);
		
		for (MDaoImpl oDao : p_oProjectConfig.getDomain().getDictionnary().getAllDaos()) {
			createDaoInterface(oDao.getMasterInterface(), p_oProjectConfig, p_oContext);
		}
		log.debug("< ActionPropertiesGenerator.genere: {}", oChrono.stopAndDisplay());
	}

	/**
	 * 
	 * 
	 * @param p_oDao
	 * @param p_oNonGeneratedBlocExtractor
	 * @param p_oProjectConfig
	 * @param p_oXslInterfaceTransformer
	 * @throws Exception
	 */
	private void createDaoInterface(MDaoInterface p_oMDaoInterface, XProject<XDomain<ModelDictionary, XModeleFactory>> p_oMProject,
			DomainGeneratorContext p_oContext) throws Exception {

		Document xDaoInterfaceDoc = DocumentHelper.createDocument(p_oMDaoInterface.toXml());

		String sInterfaceFile = p_oMProject.getSourceDir() + "/" + p_oMDaoInterface.getFullName().replaceFirst("Dao", "").replace('.', '/')
				+ "Field.java";

		this.doIncrementalTransform("dao-field-enum.xsl", sInterfaceFile, xDaoInterfaceDoc, p_oMProject, p_oContext);
	}
}
