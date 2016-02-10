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

import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.generator.core.incremental.AbstractIncrementalGenerator;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.utils.FileTypeUtils;
import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFDomain;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelDictionary;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelFactory;

/**
 * <p>
 * Generate properties of view models
 * </p>
 * 
 * <p>
 * Copyright (c) 2014
 * <p>
 * Company: Adeuza
 * 
 * @author sbernardin
 * 
 */

public class PropertiesGenerator extends AbstractIncrementalGenerator<MFDomain<MFModelDictionary, MFModelFactory>> {
	
	/**
	 * Logger
	 */
	private static final Logger log = LoggerFactory.getLogger(LabelGenerator.class);
	
	/**
	 * Generated file
	 */
	private static final String GENERATED_FILE_PROPERTY = "configDictionaryPropertiesDefault";
	
	/**
	 * Xsl file
	 */
	private static final String XSL_FILE_PROPERTIES = "dict-properties.xsl";
	
	Map<String,String> mapResource = new HashMap<String,String>();

	/**
	 * {@inheritDoc}
	 */
	public void genere( XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oProject, DomainGeneratorContext p_oGeneratorContext) throws Exception {
		log.debug("> PropertiesGenerator.genere");
		Chrono oChrono = new Chrono(true);
		
		addMainScreenProperty(p_oProject);
		
		Document xInterfacesDocumentFields = DocumentHelper.createDocument(buildDocProperties());

		doIncrementalTransform(XSL_FILE_PROPERTIES, getOutputFileProperties(p_oProject), xInterfacesDocumentFields, p_oProject, p_oGeneratorContext);

		log.debug("< PropertiesGenerator.genere: {}", oChrono.stopAndDisplay());
	}

	/**
	 * Adds main screen property to the list
	 * @param p_oMProject
	 * @throws Exception
	 */
	private void addMainScreenProperty(XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) throws Exception {
		// phone/store
		if (p_oMProject.getDomain().getDictionnary().getMainScreen() != null) {
			mapResource.put("mainscreen", p_oMProject.getDomain().getDictionnary().getMainScreen().getFullName());
		}
	}
		
	/**
	 * Build xml from map of properties
	 * @param p_xResources xml output
	 */
	private Element buildDocProperties() {
		Element xProperties = DocumentHelper.createElement("properties");
		for( Entry<String,String> oEntry : mapResource.entrySet()) {
			Element xPropertie = xProperties.addElement("property");
			xPropertie.addElement("key").setText(oEntry.getKey());;
			xPropertie.addElement("value").setText(oEntry.getValue());
		}
		return xProperties;
	}
	
	/**
	 * Return output file for xsl generation
	 * @param p_oProject project
	 * @return output file
	 */
	protected String getOutputFileProperties( XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oProject ) {
		return FileTypeUtils.computeFilenameForXmlClass(p_oProject.getSourceDir() + "/Common", GENERATED_FILE_PROPERTY);
	}
}