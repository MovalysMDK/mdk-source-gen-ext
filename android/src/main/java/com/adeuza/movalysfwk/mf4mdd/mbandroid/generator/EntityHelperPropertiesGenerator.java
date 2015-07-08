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
import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.generator.core.incremental.AbstractIncrementalGenerator;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.languages.android.xmodele.MAndroidProject;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4ADictionnary;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4ADomain;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4AModeleFactory;

/**
 * @author lmichenaud
 *
 */
public class EntityHelperPropertiesGenerator extends AbstractIncrementalGenerator<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> {

	/**
	 * 
	 */
	private static final Logger log = LoggerFactory.getLogger(EntityHelperPropertiesGenerator.class);
	
	/**
	 * (non-Javadoc)
	 * @see com.a2a.adjava.generators.ResourceGenerator#genere(com.a2a.adjava.xmodele.XProject, java.util.Map)
	 */
	@Override
	public void genere(XProject<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> p_oMProject, DomainGeneratorContext p_oContext) throws Exception {
		log.debug("> EntityHelperPropertiesGenerator.genere");
		Chrono oChrono = new Chrono(true);
		
		MAndroidProject<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> oAndroidProject = 
				(MAndroidProject<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>>) p_oMProject;
		
		Element xRoot = DocumentHelper.createElement("entity-factories");
		Document xDoc = DocumentHelper.createDocument(xRoot);
		for( MEntityImpl oClass : p_oMProject.getDomain().getDictionnary().getAllEntities()) {
			xRoot.add( oClass.toXml());
		}
		
		String sFile = FilenameUtils.concat(oAndroidProject.getRawDirectory(), "beans_entityhelper");

		log.debug("  generation du fichier {}", sFile);
		
		this.doIncrementalTransform("entityhelper-properties.xsl", sFile, xDoc, p_oMProject, p_oContext);
		
		log.debug("< EntityHelperPropertiesGenerator.genere: {}", oChrono.stopAndDisplay());
	}
}
