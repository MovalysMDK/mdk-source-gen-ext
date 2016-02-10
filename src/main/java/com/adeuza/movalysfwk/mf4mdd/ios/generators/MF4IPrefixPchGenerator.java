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
package com.adeuza.movalysfwk.mf4mdd.ios.generators;

import java.io.File;

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
import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.ios.xmodele.MF4IDictionnary;
import com.adeuza.movalysfwk.mf4mdd.ios.xmodele.MF4IDomain;
import com.adeuza.movalysfwk.mf4mdd.ios.xmodele.MF4IImportDelegate;
import com.adeuza.movalysfwk.mf4mdd.ios.xmodele.MF4IModelFactory;

/**
 * Prefix.pch generation (injection).
 * Complete prefix.pch with missing imports.
 * @author lmichenaud
 *
 */
public class MF4IPrefixPchGenerator extends AbstractInjectionGenerator<MF4IDomain<MF4IDictionnary, MF4IModelFactory>> {

	/**
	 * Logger
	 */
	private static final Logger log = LoggerFactory.getLogger(MF4IPrefixPchGenerator.class);

	/**
	 * Prefix.pch xsl template
	 */
	private static final String PREFIXPCH_XSL = "prefixpch.xsl";
	
	/**
	 * Génère l'interface SuperEntityFactory
	 * @param p_oMProject current project
	 * @param p_oContext context to use
	 * @throws Exception exception
	 */
	@Override
	public void genere( XProject<MF4IDomain<MF4IDictionnary, MF4IModelFactory>> p_oMProject, DomainGeneratorContext p_oContext) throws Exception {
		
		log.debug("> MF4IPrefixPchGenerator.genere");
		Chrono oChrono = new Chrono(true);
		
		MF4IImportDelegate oImportDlg = new MF4IImportDelegate(this);
		this.computeImports( oImportDlg, p_oMProject);
		
		Element xRoot = DocumentHelper.createElement("prefixpch");
		Document xDoc = DocumentHelper.createDocument(xRoot);
		xRoot.add(oImportDlg.toXml());
		
		File oTargetFile = new File(p_oMProject.getSourceDir(), "Prefix.pch");
		
		FilePartGenerationConfig oFilePartGenerationConfig = new FilePartGenerationConfig(
				"gen-imports", PREFIXPCH_XSL, xDoc);
		
		log.debug("generate prefix.pch file: {}", oTargetFile.getPath());
		this.doInjectionTransform(oTargetFile.getPath(), p_oMProject, p_oContext, oFilePartGenerationConfig);
		
		if (isDebug()) {
			GeneratorUtils.writeXmlDebugFile(xDoc, oTargetFile.getPath() + ".xml", p_oMProject);
		}
		
		log.debug("< MF4IPrefixPchGenerator.genere: {}", oChrono.stopAndDisplay());
	}

	/**
	 * Compute import delegates
	 * @param p_oImportDlg import delegates
	 * @param p_oMProject project
	 */
	protected void computeImports(MF4IImportDelegate p_oImportDlg,
			XProject<MF4IDomain<MF4IDictionnary, MF4IModelFactory>> p_oMProject) {
		// nothing do do
	}
}
