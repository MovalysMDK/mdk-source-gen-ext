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

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.codeformatter.GeneratedFile;
import com.a2a.adjava.generator.codeformatters.XmlFormatOptions;
import com.a2a.adjava.generator.core.override.AbstractOverrideGenerator;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.html5.xmodele.MF4HDictionary;
import com.adeuza.movalysfwk.mf4mdd.html5.xmodele.MF4HDomain;
import com.adeuza.movalysfwk.mf4mdd.html5.xmodele.MF4HModelFactory;

/**
 * <p>
 * 	Generate schema creation script and schema drop script.
 * </p>
 * 
 * <p>Copyright (c) 2009</p>
 * <p>Company: Adeuza</p>
 * 
 */
public class JsonSchemaGenerator extends AbstractOverrideGenerator<MF4HDomain<MF4HDictionary, MF4HModelFactory>> {

	/**
	 * 
	 */
	private static final Logger log = LoggerFactory.getLogger(JsonSchemaGenerator.class);
	
	private static final String jsonSqlDataPath = "webapp/src/assets/data/nosql/";

	/**
	 * {@inheritDoc}
	 */
	@Override
	public void genere(XProject<MF4HDomain<MF4HDictionary, MF4HModelFactory>> p_oProject, DomainGeneratorContext p_oContext) throws Exception {

		log.debug("> JsonSchemaGenerator.genere");		Chrono oChrono = new Chrono(true);

		
		Element xRoot = DocumentHelper.createElement("json_usermodel");
		Document xDoc = DocumentHelper.createDocument(xRoot);
				
		for (MEntityImpl oMEntityImpl : p_oProject.getDomain().getDictionnary().getAllEntities()) {
			xRoot.add(oMEntityImpl.toXml());
		}
		
		XmlFormatOptions oFormatOptions = new XmlFormatOptions();
		oFormatOptions.setUseDom4j(true);
		oFormatOptions.setStandalone(true);
		oFormatOptions.setNewLineAfterDeclaration(false);
		
		/* CREATE FILES JSON */
		String sJsonCreateFileFwkModel = jsonSqlDataPath + "create_usermodel.json";
		File oContentCreateFile = new File(sJsonCreateFileFwkModel);
		GeneratedFile<XmlFormatOptions> oGenCreateFile = new GeneratedFile<XmlFormatOptions>(oContentCreateFile, oFormatOptions);

		this.doOverrideTransform( "database/json-schema-create-usermodel.xsl", oGenCreateFile, xDoc, p_oProject, p_oContext);
		
		/* DELETE FILES JSON*/
		String sJsonDropFileFwkModel = jsonSqlDataPath + "list_usermodel.json";
		File oContentDropFile = new File(sJsonDropFileFwkModel);
		GeneratedFile<XmlFormatOptions> oGenDropFile = new GeneratedFile<XmlFormatOptions>(oContentDropFile, oFormatOptions);

		this.doOverrideTransform( "database/json-schema-drop-usermodel.xsl", oGenDropFile, xDoc, p_oProject, p_oContext);
	
		
		log.debug("< JsonSchemaGenerator.genere: {}", oChrono.stopAndDisplay());
	}
}
