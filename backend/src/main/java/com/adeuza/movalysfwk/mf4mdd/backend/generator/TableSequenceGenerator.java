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
package com.adeuza.movalysfwk.mf4mdd.backend.generator;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.generator.core.override.AbstractOverrideGenerator;
import com.a2a.adjava.generator.impl.SchemaGenerator;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.xmodele.ModelDictionary;
import com.a2a.adjava.xmodele.XDomain;
import com.a2a.adjava.xmodele.XModeleFactory;
import com.a2a.adjava.xmodele.XProject;

/**
 * <p>TODO Décrire la classe TableSequenceGenerator</p>
 *
 * <p>Copyright (c) 2011
 * <p>Company: Adeuza
 *
 * @author lmichenaud
 *
 */

public class TableSequenceGenerator extends AbstractOverrideGenerator<XDomain<ModelDictionary,XModeleFactory>> {

	/**
	 * 
	 */
	private static final Logger log = LoggerFactory.getLogger(SchemaGenerator.class);
	
	/*
	 * (non-Javadoc)
	 * 
	 * @see com.a2a.adjava.generator.ResourceGenerator#genere(com.a2a.adjava.project.ProjectConfig,
	 *      com.a2a.adjava.xmodele.MModele)
	 */
	public void genere(XProject<XDomain<ModelDictionary,XModeleFactory>> p_oXProject, DomainGeneratorContext p_oContext) throws Exception {
		
		Document xSchema = DocumentHelper.createDocument(p_oXProject.getDomain().getSchema().toXml());

		String sTableSequencesFile = p_oXProject.getDdlDir() + "/tablesequences.properties" ;
		
		log.debug(" sTableSequencesFile = "+sTableSequencesFile);
		
		log.debug("génération du fichier " + sTableSequencesFile);
		this.doOverrideTransform("tablesequences.xsl", sTableSequencesFile, xSchema, p_oXProject, p_oContext);

	}
}
