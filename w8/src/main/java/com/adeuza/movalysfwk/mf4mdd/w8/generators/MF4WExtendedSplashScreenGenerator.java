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

import com.a2a.adjava.generator.core.GeneratorUtils;
import com.a2a.adjava.generator.core.injection.AbstractInjectionGenerator;
import com.a2a.adjava.generator.core.injection.FilePartGenerationConfig;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFDomain;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelDictionary;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelFactory;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashSet;
import java.util.Set;

/**
 *
 */
public class MF4WExtendedSplashScreenGenerator extends AbstractInjectionGenerator<MFDomain<MFModelDictionary, MFModelFactory>> {

	/**
	 * Logger
	 */
	private static final Logger log = LoggerFactory.getLogger(LabelGenerator.class);

	/**
	 * Targeted file path, relative to the project source directory
	 */
	private static final String TARGETED_FILE_PATH = "/View/Screens/ExtendedSplash.xaml.cs";
	/**
	 * Flag defined inside the file where the code will be placed
	 */
	private static final String NAVIGATION_SERVICE_FLAG = "navigation-service";
	/**
	 * Flag defined inside the file where the code will be placed
	 */
	private static final String NAVIGATION_IMPORTS_FLAG = "navigation-imports";
	/**
	 * Xsl file to use during the generation
	 */
	private static final String NAVIGATION_SERVICE_XSL_FILE = "navigation-service.xsl";
	/**
	 * Xsl file to use during the generation
	 */
	private static final String NAVIGATION_IMPORTS_XSL_FILE = "navigation-service-imports.xsl";

	@Override
	public void genere(XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject, DomainGeneratorContext p_oGeneratorContext) throws Exception {

		log.debug("> ManifestGenerator.genere");
		Chrono oChrono = new Chrono(true);

		// For each screen, add an entry containing the data used to initialize the navigation service.
		// This includes : the vm name, the vm interface name, and the screen name
		Element oNavigationEntries = DocumentHelper.createElement("navigation-entries");
		Set<String> imports = new HashSet<>();
		Element oImports = DocumentHelper.createElement("imports");

		for (MScreen oScreen : p_oMProject.getDomain().getDictionnary().getAllScreens()) {
			Element oEntry = DocumentHelper.createElement("entry");

			Element oKey = DocumentHelper.createElement("key");
			oKey.setText(oScreen.getViewModel().getName());
			oEntry.add(oKey);

			Element oIVMName = DocumentHelper.createElement("ivm-name");
			oIVMName.setText(oScreen.getViewModel().getMasterInterface().getName());
			oEntry.add(oIVMName);

			Element oScreenName = DocumentHelper.createElement("screen-name");
			oScreenName.setText(oScreen.getName());
			oEntry.add(oScreenName);

			oNavigationEntries.add(oEntry);

			imports.add(oScreen.getPackage().getFullName());
		}

		for (String importName : imports) {
			Element _import = DocumentHelper.createElement("import");
			_import.setText(importName);
			oImports.add(_import);
		}
		oNavigationEntries.add(oImports);

		// Compute the file path
		StringBuilder oTargetFilePathBuilder = new StringBuilder(p_oMProject.getSourceDir());
		oTargetFilePathBuilder.append(TARGETED_FILE_PATH);
		String sTargetFilePath = oTargetFilePathBuilder.toString();
		// Convert the Element into a Document
		Document xDoc = DocumentHelper.createDocument(oNavigationEntries);
		// Create the generation configuration part
		FilePartGenerationConfig oNavigationServiceConfig = new FilePartGenerationConfig(
				NAVIGATION_SERVICE_FLAG, NAVIGATION_SERVICE_XSL_FILE, xDoc);
		FilePartGenerationConfig oNavigationImportsConfig = new FilePartGenerationConfig(
				NAVIGATION_IMPORTS_FLAG, NAVIGATION_IMPORTS_XSL_FILE, xDoc);
		// Process the generation
		this.doInjectionTransform(sTargetFilePath, p_oMProject, p_oGeneratorContext, oNavigationServiceConfig, oNavigationImportsConfig);

		if (isDebug()) {
			GeneratorUtils.writeXmlDebugFile(xDoc, sTargetFilePath, p_oMProject);
		}

		log.debug("< ManifestGenerator.genere: {}", oChrono.stopAndDisplay());
	}
}
