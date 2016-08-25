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
package com.adeuza.movalysfwk.mf4mdd.ionic2.generators;

import com.adeuza.movalysfwk.mf4mdd.ionic2.xmodele.MF4HDictionary;
import com.adeuza.movalysfwk.mf4mdd.ionic2.xmodele.MF4HDomain;
import com.adeuza.movalysfwk.mf4mdd.ionic2.xmodele.MF4HModelFactory;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.generator.core.GeneratorUtils;
import com.a2a.adjava.generator.core.injection.AbstractInjectionGenerator;
import com.a2a.adjava.generator.core.injection.FilePartGenerationConfig;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.languages.ionic2.xmodele.MH5View;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.xmodele.XProject;

/**
 * <p>
 * Generate the correct ConfigCtrl of the app
 * </p>
 * 
 * <p>
 * Copyright (c) 2011
 * <p>
 * Company: Adeuza
 * 
 * 
 */

public class ConfigCtrlGenerator extends AbstractInjectionGenerator<MF4HDomain<MF4HDictionary, MF4HModelFactory>> {

	/**
	 * 
	 */
	private static final Logger log = LoggerFactory.getLogger(ConfigCtrlGenerator.class);

	/**
	 * Génère l'interface SuperEntityFactory
	 */
	@Override
	public void genere(XProject<MF4HDomain<MF4HDictionary, MF4HModelFactory>> p_oMProject, DomainGeneratorContext p_oContext) throws Exception {
		
		log.debug("> ConfigCtrlGenerator.genere");
		Chrono oChrono = new Chrono(true);
		if ( !p_oMProject.getDomain().getDictionnary().getAllMH5Views().isEmpty()) {
			Element xElement = DocumentHelper.createElement("views");
			xElement.addAttribute("root-package", p_oMProject.getDomain().getRootPackage());
			for (MH5View oView : p_oMProject.getDomain().getDictionnary().getAllMH5Views()) {
				// Ajout du noeud XML associé à l'interface courante
				if(oView.isMainScreen())
				{
					xElement.add(oView.toXml());
				}
			}
			
			String sTargetFile = "webapp/src/app/views/configScreen/ConfigCtrl.js";
		
			Document xDoc = DocumentHelper.createDocument(xElement);

			FilePartGenerationConfig oFilePartGenerationConfig = new FilePartGenerationConfig(
					"config-ctrl-exitState", "exit-state-filler.xsl", xDoc);

			log.debug("generate project configuration file " + sTargetFile);
			this.doInjectionTransform(sTargetFile, p_oMProject, p_oContext, oFilePartGenerationConfig);

			//android ne compile pas sinon touver une autre solution
			if (isDebug()) {
				GeneratorUtils.writeXmlDebugFile(xDoc, sTargetFile + ".xml", p_oMProject);
			}

		}
		
		log.debug("< ConfigCtrlGenerator.genere: {}", oChrono.stopAndDisplay());
	}
}