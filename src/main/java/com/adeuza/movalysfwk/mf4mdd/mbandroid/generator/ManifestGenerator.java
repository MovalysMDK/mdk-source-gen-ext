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

import com.a2a.adjava.generator.core.GeneratorUtils;
import com.a2a.adjava.generator.core.injection.AbstractInjectionGenerator;
import com.a2a.adjava.generator.core.injection.FilePartGenerationConfig;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4ADictionnary;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4ADomain;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4AModeleFactory;

/**
 * <p>
 * Generate SuperFactory of Dao
 * </p>
 * 
 * <p>
 * Copyright (c) 2011
 * <p>
 * Company: Adeuza
 * 
 * @author smaitre
 * 
 */

public class ManifestGenerator extends AbstractInjectionGenerator<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> {

	/**
	 * 
	 */
	private static final Logger log = LoggerFactory.getLogger(ManifestGenerator.class);

	/**
	 * Génère l'interface SuperEntityFactory
	 */
	@Override
	public void genere( XProject<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> p_oMProject, DomainGeneratorContext p_oContext) throws Exception {
		
		log.debug("> ManifestGenerator.genere");
		Chrono oChrono = new Chrono(true);
		
		if ( !p_oMProject.getDomain().getDictionnary().getAllScreens().isEmpty()) {
			Element xElement = DocumentHelper.createElement("screens");
			xElement.addAttribute("root-package", p_oMProject.getDomain().getRootPackage());
			for (MScreen oLayout : p_oMProject.getDomain().getDictionnary().getAllScreens()) {
				// Ajout du noeud XML associé à l'interface courante
				xElement.add(oLayout.toXml());
			}
			String sTargetFile = "AndroidManifest.xml";
		
			Document xDoc = DocumentHelper.createDocument(xElement);
			
			FilePartGenerationConfig oFilePartGenerationConfig = new FilePartGenerationConfig(
					"gen-activities", "manifest.xsl", xDoc);
			
			log.debug("generate manifest file " + sTargetFile);
			this.doInjectionTransform(sTargetFile, p_oMProject, p_oContext, oFilePartGenerationConfig);
	
			//android ne compile pas sinon touver une autre solution
			if (isDebug()) {
				GeneratorUtils.writeXmlDebugFile(xDoc, sTargetFile + ".xml", p_oMProject);
			}
		}
		
		log.debug("< ManifestGenerator.genere: {}", oChrono.stopAndDisplay());
	}
}