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

import org.apache.commons.io.FilenameUtils;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.generator.core.override.AbstractOverrideGenerator;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.languages.android.xmodele.MAndroidProject;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4ADictionnary;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4ADomain;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4AModeleFactory;

/**
 * <p>
 * 	Generate schema creation script and schema drop script.
 * </p>
 * 
 * <p>Copyright (c) 2009</p>
 * <p>Company: Adeuza</p>
 * 
 * @author lmichenaud
 */
public class SqliteSchemaGenerator extends AbstractOverrideGenerator<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> {

	/**
	 * 
	 */
	private static final Logger log = LoggerFactory.getLogger(SqliteSchemaGenerator.class);

	/**
	 * {@inheritDoc}
	 */
	@Override
	public void genere(XProject<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> p_oProject, DomainGeneratorContext p_oContext) throws Exception {

		log.debug("> SqliteSchemaGenerator.genere");
		Chrono oChrono = new Chrono(true);
		
		MAndroidProject<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> oAndroidProject = 
				(MAndroidProject<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>>) p_oProject;
		
		Document xSchema = DocumentHelper.createDocument(p_oProject.getDomain().getSchema().toXml());

		/* CREATE FILES */
		String sCreateFileFwkModel = FilenameUtils.concat(oAndroidProject.getRawDirectory(), "sqlitecreate_usermodel");
		log.debug("  generate file: {}", sCreateFileFwkModel);
		this.doOverrideTransform("schema-create-usermodel.xsl", sCreateFileFwkModel, xSchema, p_oProject, p_oContext);

		/* DELETE FILES */
		String sDropFileFwkModel = FilenameUtils.concat(oAndroidProject.getRawDirectory(), "sqlitedrop_usermodel");
		log.debug("  generate file: {}", sDropFileFwkModel);
		this.doOverrideTransform("schema-drop-usermodel.xsl", sDropFileFwkModel, xSchema, p_oProject, p_oContext);
		
		log.debug("< SqliteSchemaGenerator.genere: {}", oChrono.stopAndDisplay());
	}
}