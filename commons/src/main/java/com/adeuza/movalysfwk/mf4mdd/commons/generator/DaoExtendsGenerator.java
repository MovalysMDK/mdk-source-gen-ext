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
package com.adeuza.movalysfwk.mf4mdd.commons.generator;

import java.beans.Introspector;
import java.util.Map;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.generator.core.incremental.AbstractIncrementalGenerator;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.schema.Schema;
import com.a2a.adjava.xmodele.MDaoExtends;
import com.a2a.adjava.xmodele.MDaoImpl;
import com.a2a.adjava.xmodele.ModelDictionary;
import com.a2a.adjava.xmodele.XDomain;
import com.a2a.adjava.xmodele.XModeleFactory;
import com.a2a.adjava.xmodele.XProject;

/**
 * 
 * <p>
 * Dao Generator
 * </p>
 * 
 * <p>
 * Copyright (c) 2009
 * </p>
 * <p>
 * Company: Adeuza
 * </p>
 * 
 */
public class DaoExtendsGenerator extends AbstractIncrementalGenerator<XDomain<ModelDictionary,XModeleFactory>> {

	/**
	 * Logger for this class
	 */
	private static final Logger log = LoggerFactory.getLogger(DaoExtendsGenerator.class);

	/**
	 * {@inheritDoc}
	 * 
	 * @see com.a2a.adjava.generator.ResourceGenerator#genere(ProjectConfig, MModele, Schema, Map)
	 */
	public void genere(XProject<XDomain<ModelDictionary,XModeleFactory>> p_oMProject, DomainGeneratorContext p_oContext) throws Exception {
		log.debug("> DaoExtendsGenerator.genere");

		for (MDaoImpl oDao : p_oMProject.getDomain().getDictionnary().getAllDaos()) {
			createDaoExtends(oDao, p_oMProject, p_oContext);
		}

		log.debug("< DaoExtendsGenerator.genere");
	}

	/**
	 * Method to create dao implementation.
	 * 
	 * @param p_oDao
	 *            dao abstrait
	 * @param p_oNonGeneratedBlocExtractor
	 *            non generated bloc extrator
	 * @param p_oProjectConfig
	 *            configuration du projet
	 * 
	 * @throws Exception
	 *             error
	 */
	private void createDaoExtends(MDaoImpl p_oDao, 
			XProject<XDomain<ModelDictionary,XModeleFactory>> p_oMProject, DomainGeneratorContext p_oContext) throws Exception {

		String sName = p_oDao.getMEntityImpl().getName()
				.substring(0, p_oDao.getMEntityImpl().getName().length() - p_oMProject.getDomain().getLanguageConf().getImplNamingSuffix().length());
		// Calcule le nom du Dao
		String sDaoExtendsName = sName + this.getParametersMap().get("suffix-naming");

		String sDaoExtendsBeanName = Introspector.decapitalize(sName + p_oMProject.getDomain().getLanguageConf().getDaoInterfaceNamingSuffix());

		MDaoExtends oDaoExtends = new MDaoExtends(sDaoExtendsName, sDaoExtendsBeanName, p_oDao);

		Document xDaoExtends = DocumentHelper.createDocument(oDaoExtends.toXml());

		String sDaoFile = p_oMProject.getSourceDir() + "/" + oDaoExtends.getFullName().replace('.', '/') + ".java";

		log.debug("Generate file : " + sDaoFile);
		this.doIncrementalTransform("dao-extends.xsl", sDaoFile, xDaoExtends, p_oMProject, p_oContext);
	}
}
