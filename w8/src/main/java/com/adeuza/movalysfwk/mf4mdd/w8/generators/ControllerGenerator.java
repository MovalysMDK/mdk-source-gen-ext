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

import com.a2a.adjava.generator.core.incremental.AbstractIncrementalGenerator;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.utils.FileTypeUtils;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFDomain;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelDictionary;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelFactory;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Generates all the screen controllers, that are in charge of being interfaces between multiple layers
 * (dataloaders, viewmodels, other user specific services,...)
 */
public class ControllerGenerator extends AbstractIncrementalGenerator<MFDomain<MFModelDictionary, MFModelFactory>> {

	/**
	 * Logger
	 */
	private static final Logger log = LoggerFactory
			.getLogger(ScreenGenerator.class);

	/**
	 * Template for generating the screen controller
	 */
	private static final String SCREEN_CONTROLLER_TEMPLATE = "controller/screen-controller.xsl";

	/**
	 *
	 * @param p_oMProject
	 * @param p_oGeneratorContext
	 * @throws Exception
	 */
	@Override
	public void genere(XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject, DomainGeneratorContext p_oGeneratorContext) throws Exception {

		log.debug("> ControllerGenerator.genere");
		Chrono oChrono = new Chrono(true);
		for (MScreen oMScreen : p_oMProject.getDomain().getDictionnary().getAllScreens()) {
			this.createScreenController(oMScreen, p_oMProject, p_oGeneratorContext);
		}
		log.debug("< ControllerGenerator.genere: {}", oChrono.stopAndDisplay());
	}

	private void createScreenController(MScreen p_oScreen, XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject,
	                                    DomainGeneratorContext p_oGeneratorContext) throws Exception {

		// Compute the controller file name
		String controllerName = p_oScreen.getName()+"Controller";
		String sControllerFileName = FileTypeUtils.computeFilenameForCSharpImpl("Application.Controllers", controllerName, p_oMProject.getSourceDir());
		// Convert the screen to xml
		Element oElement = p_oScreen.toXml();

		this.doIncrementalTransform(SCREEN_CONTROLLER_TEMPLATE, sControllerFileName,
				DocumentHelper.createDocument(oElement), p_oMProject, p_oGeneratorContext);
	}
}
