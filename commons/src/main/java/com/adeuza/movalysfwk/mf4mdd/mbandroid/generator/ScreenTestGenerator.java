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
import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.generator.core.incremental.AbstractIncrementalGenerator;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.ModelDictionary;
import com.a2a.adjava.xmodele.XDomain;
import com.a2a.adjava.xmodele.XModeleFactory;
import com.a2a.adjava.xmodele.XProject;

public class ScreenTestGenerator extends AbstractIncrementalGenerator<XDomain<ModelDictionary, XModeleFactory>> {

	/**
	 * Logger
	 */
	private static final Logger log = LoggerFactory.getLogger(ScreenTestGenerator.class);
	
	/**
	 * (non-Javadoc)
	 * 
	 * @see com.a2a.adjava.generator.ResourceGenerator#genere(com.a2a.adjava.project.ProjectConfig, com.a2a.adjava.xmodele.MModele,
	 *      com.a2a.adjava.schema.Schema, java.util.Map)
	 */
	public void genere(XProject<XDomain<ModelDictionary, XModeleFactory>> p_oProjectConfig, DomainGeneratorContext p_oContext) throws Exception {
		log.debug("> ScreenTestGenerator.genere");
		Chrono oChrono = new Chrono(true);
		
		for( MScreen oScreen : p_oProjectConfig.getDomain().getDictionnary().getAllScreens()) {
			createScreenTest(oScreen, p_oProjectConfig, p_oContext);
		}

		log.debug("< ScreenTestGenerator.genere: {}", oChrono.stopAndDisplay());
	}
	
	/**
	 * 
	 * 
	 * @param p_oScreen
	 * @param p_oNonGeneratedBlocExtractor
	 * @param p_oProjectConfig
	 * @param p_oXslInterfaceTransformer
	 * @throws Exception
	 */
	private void createScreenTest(MScreen p_oScreen, XProject<XDomain<ModelDictionary, XModeleFactory>> p_oMProject,
			DomainGeneratorContext p_oContext) throws Exception {

		Document xScreenTestDoc = DocumentHelper.createDocument(p_oScreen.toXml());
		Element xRootElement = xScreenTestDoc.getRootElement();
		if ( p_oScreen.getLayout() != null ) {
			xRootElement.add(p_oScreen.getLayout().toXml());
		}
		xRootElement.addElement("master-package").setText(p_oMProject.getDomain().getRootPackage());
		
		//TODO: configure IT Tests directory
		String sScreenTestFile = "src/androidTest/java/" + p_oScreen.getFullName().replace('.', '/')
				+ "Test.java";

		this.doIncrementalTransform("tests/screen.xsl", sScreenTestFile, xScreenTestDoc, p_oMProject, p_oContext);
	}
}
