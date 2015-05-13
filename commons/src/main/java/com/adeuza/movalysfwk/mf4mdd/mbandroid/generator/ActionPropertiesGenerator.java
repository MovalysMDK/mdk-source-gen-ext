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
import com.a2a.adjava.xmodele.MAction;
import com.a2a.adjava.xmodele.ModelDictionary;
import com.a2a.adjava.xmodele.XDomain;
import com.a2a.adjava.xmodele.XModeleFactory;
import com.a2a.adjava.xmodele.XProject;

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

public class ActionPropertiesGenerator extends AbstractOverrideGenerator<XDomain<ModelDictionary, XModeleFactory>> {

	/**
	 * 
	 */
	private static final Logger log = LoggerFactory.getLogger(ActionPropertiesGenerator.class);
	
	private static final String XSL_FILE_NAME = "action-properties.xsl";

	private static final String GENERATED_FILE = "beans_action";

	/**
	 * Generate properties
	 */
	@Override
	public void genere( XProject<XDomain<ModelDictionary, XModeleFactory>> p_oMProject, DomainGeneratorContext p_oContext) throws Exception {
		log.debug("> ActionPropertiesGenerator.genere");
		Chrono oChrono = new Chrono(true);
		Element xVms = DocumentHelper.createElement("actions");

		Element xElement = null;
		for (MAction oVm : p_oMProject.getDomain().getDictionnary().getAllActions()) {
			// Ajout du noeud XML associé à l'interface courante
			xElement = xVms.addElement("action");
			xElement.addElement("itf").setText(oVm.getMasterInterface().getFullName());
			xElement.addElement("impl").setText(oVm.getFullName());
			if (oVm.isRoot()) {
				xElement = xVms.addElement("action");
				xElement.addElement("itf").setText("com.adeuza.movalysfwk.mobile.mf4mjcommons.business.displaymain.DisplayMainAction");
				xElement.addElement("impl").setText(oVm.getFullName());
			}
		}
			
		this.addInitAction(xVms, p_oMProject);
		String sTargetFile = new StringBuilder("res/raw/")
				.append(GENERATED_FILE).toString();

		log.debug("  generation du fichier {}", sTargetFile);
		
		Document xInterfacesDocument = DocumentHelper.createDocument(xVms);
		this.doOverrideTransform(XSL_FILE_NAME, sTargetFile, xInterfacesDocument, p_oMProject, p_oContext);
		
		log.debug("< ActionPropertiesGenerator.genere: {}", oChrono.stopAndDisplay());
	}
	
	/**
	 * @param xVms
	 * @param p_oMProject
	 */
	private void addInitAction(Element xVms , XProject<XDomain<ModelDictionary, XModeleFactory>> p_oMProject){
		// Ajout des implementations des process de demarrage perso
		Element xElement = xVms.addElement("action");
		xElement.addElement("itf").setText("com.adeuza.movalysfwk.mobile.mf4mjcommons.application.CustomInit");
		xElement.addElement("impl").setText(p_oMProject.getDomain().getRootPackage() + ".CustomInitImpl");
		
		xElement = xVms.addElement("action");
		xElement.addElement("itf").setText("com.adeuza.movalysfwk.mobile.mf4mjcommons.application.CustomApplicationInit");
		xElement.addElement("impl").setText(p_oMProject.getDomain().getRootPackage() + ".CustomApplicationInitImpl");
	}
}
