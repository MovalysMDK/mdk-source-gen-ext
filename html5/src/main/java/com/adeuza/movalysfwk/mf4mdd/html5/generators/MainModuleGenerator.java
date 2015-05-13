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

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.generator.core.GeneratorUtils;
import com.a2a.adjava.generator.core.injection.AbstractInjectionGenerator;
import com.a2a.adjava.generator.core.injection.FilePartGenerationConfig;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.languages.html5.xmodele.MH5View;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.html5.xmodele.MF4HDictionary;
import com.adeuza.movalysfwk.mf4mdd.html5.xmodele.MF4HDomain;
import com.adeuza.movalysfwk.mf4mdd.html5.xmodele.MF4HModelFactory;

public class MainModuleGenerator extends AbstractInjectionGenerator<MF4HDomain<MF4HDictionary, MF4HModelFactory>> {

	/**
	 * Logger
	 */
	private static final Logger log = LoggerFactory.getLogger(MainModuleGenerator.class);
	
	
	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.generators.ResourceGenerator#genere(com.a2a.adjava.xmodele.XProject, com.a2a.adjava.generators.DomainGeneratorContext)
	 */
	@Override
	public void genere( XProject<MF4HDomain<MF4HDictionary, MF4HModelFactory>> p_oMProject,
			DomainGeneratorContext p_oGeneratorContext) throws Exception {
		
		log.debug("> MainModuleGenerator.genere");
		Chrono oChrono = new Chrono(true);	
		this.createMainModule(p_oMProject, p_oGeneratorContext);
		log.debug("< MainModuleGenerator.genere: {}", oChrono.stopAndDisplay());
	}
	
	
	
	
	/**
	 * @param p_oNonGeneratedBlocExtractor
	 * @param p_oProject
	 * @param p_oContext
	 * @throws Exception
	 */
	private void createMainModule(XProject<MF4HDomain<MF4HDictionary, MF4HModelFactory>> p_oMProject,
			DomainGeneratorContext p_oGeneratorContext) throws Exception {
		
		Element r_xMainAppFile = DocumentHelper.createElement("main-module");
		Element r_xViewFile = DocumentHelper.createElement("views");
		for(MH5View oMH5View : p_oMProject.getDomain().getDictionnary().getAllMH5Views()) {
			r_xViewFile.add(oMH5View.toXml());
		}
		r_xMainAppFile.add(r_xViewFile);

		Document xViewModelDoc = DocumentHelper.createDocument(r_xMainAppFile);
		String sTargetFile = "webapp/src/app/modules.js";

		log.debug("  generation du fichier modules.js");
		//first injection, module-declaration in module.js
		FilePartGenerationConfig oFilePartGenerationModuleDeclaration = new FilePartGenerationConfig( "module-declaration", "mainapp/module-declaration.xsl", xViewModelDoc);
		this.doInjectionTransform(sTargetFile, p_oMProject, p_oGeneratorContext, oFilePartGenerationModuleDeclaration);
		
		
		//first injection, module-declaration in module.js
		FilePartGenerationConfig oFilePartGenerationModuleImports = new FilePartGenerationConfig( "module-imports", "mainapp/module-imports.xsl", xViewModelDoc);
		this.doInjectionTransform(sTargetFile, p_oMProject, p_oGeneratorContext, oFilePartGenerationModuleImports);
		
		
		//android ne compile pas sinon touver une autre solution
		if (isDebug()) {
			GeneratorUtils.writeXmlDebugFile(xViewModelDoc, sTargetFile + ".xml", p_oMProject);
		}
		
		
	}





}
