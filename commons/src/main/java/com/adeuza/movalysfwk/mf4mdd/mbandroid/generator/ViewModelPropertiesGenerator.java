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

import com.a2a.adjava.generator.core.override.AbstractOverrideGenerator;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.xmodele.MViewModelImpl;
import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4ADictionnary;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4ADomain;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4AModeleFactory;

/**
 * <p>
 * Generate properties of view models
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

public class ViewModelPropertiesGenerator extends AbstractOverrideGenerator<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> {

	private static final Logger log = LoggerFactory.getLogger(ViewModelPropertiesGenerator.class);
	
	private static final String XSL_FILE_NAME = "viewmodel-properties.xsl";

	private static final String GENERATED_FILE = "beans_viewmodel";

	/**
	 * Generate properties
	 */
	@Override
	public void genere( XProject<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> p_oMProject, DomainGeneratorContext p_oContext) throws Exception {

		log.debug("> ViewModelPropertiesGenerator.genere");
		Chrono oChrono = new Chrono(true);
		
			Element xVms = DocumentHelper.createElement("viewmodels");

			Element xElement = xVms.addElement("vm");
			if (p_oMProject.getDomain().getDictionnary().getViewModelCreator()!=null) {
				xElement.addElement("itf").setText("viewmodelcreator");
				xElement.addElement("impl").setText(p_oMProject.getDomain().getDictionnary().getViewModelCreator().getFullName());
			}
			for (MViewModelImpl oVm : p_oMProject.getDomain().getDictionnary().getAllViewModels()) {
					xElement = xVms.addElement("vm");
					xElement.addElement("itf").setText(oVm.getMasterInterface().getFullName());
					xElement.addElement("impl").setText(oVm.getFullName());
			}

			String sTargetFile = new StringBuilder("res/raw/")
					.append(GENERATED_FILE).toString();

			Document xInterfacesDocument = DocumentHelper.createDocument(xVms);
			this.doOverrideTransform(XSL_FILE_NAME, sTargetFile, xInterfacesDocument, p_oMProject, p_oContext);
		
		
		log.debug("< ViewModelPropertiesGenerator.genere: {}", oChrono.stopAndDisplay());
		}
	}