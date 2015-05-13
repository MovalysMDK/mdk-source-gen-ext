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

import java.util.ArrayList;
import java.util.List;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.generator.core.incremental.AbstractIncrementalGenerator;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.utils.FileTypeUtils;
import com.a2a.adjava.xmodele.MPage;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFDomain;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelDictionary;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelFactory;
import com.adeuza.movalysfwk.mf4mdd.w8.extractor.MF4WScreenDependencyProcessor.MF4WNavigationV2;
import com.adeuza.movalysfwk.mf4mdd.w8.xmodele.MF4WPage;

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

public class EventGenerator extends AbstractIncrementalGenerator<MFDomain<MFModelDictionary, MFModelFactory>> {
	
	/**
	 * Logger
	 */
	private static final Logger log = LoggerFactory.getLogger(EventGenerator.class);
	
	/**
	 * Generated file
	 */
	private static final String GENERATED_FILE_EVENT = "MFEvent";
	
	/**
	 * Xsl file
	 */
	private static final String XSL_FILE_RESOURCE_CS = "view/event.xsl";
	
	List<Element> mapEvents = new ArrayList<Element>();

	/**
	 * {@inheritDoc}
	 */
	public void genere(
			XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject,
			DomainGeneratorContext p_oGeneratorContext) throws Exception {
		log.debug("> EventGenerator.genere");
		Chrono oChrono = new Chrono(true);
		boolean IsEmpty = true;
		String panelPackage = "";
		String parentViewModel = "";
		Element xEvent = DocumentHelper.createElement("events");
		for(MScreen oScreen : p_oMProject.getDomain().getDictionnary().getAllScreens()) {
			for (MPage oPage : oScreen.getPages()) {
				MF4WPage page = (MF4WPage) oPage;
				panelPackage = page.getPackage().getFullName();
				if(oPage.getViewModelImpl() != null && oPage.getViewModelImpl().getFirstParent() != null){
					parentViewModel = oPage.getViewModelImpl().getFirstParent().getName();
				}
				for(MF4WNavigationV2 navigation : page.getNavigationV2()){
					mapEvents.add(navigation.toXml());
					IsEmpty = false;
				}
			}
		}
		xEvent.addElement("parent-viewmodel").setText(parentViewModel);
		xEvent.addElement("package").setText(panelPackage);
		this.buildDocEvents(xEvent);		
		Document xEvents = DocumentHelper.createDocument(xEvent);
		String fileName = FileTypeUtils.computeFilenameForCSharpImpl(
				"View", GENERATED_FILE_EVENT,p_oMProject.getSourceDir());
		if(!IsEmpty)
		{
			this.doIncrementalTransform(XSL_FILE_RESOURCE_CS, fileName, xEvents, p_oMProject, p_oGeneratorContext);
		}
		log.debug("< EventGenerator.genere: {}", oChrono.stopAndDisplay());
	}


		
	/**
	 * Build xml from map of labels
	 * @param p_mapLabels map of labels
	 * @param p_xLabels xml output
	 * @param p_oLocale locale
	 */
	private void buildDocEvents(Element p_xEvent) {
		for( Element oEntry : mapEvents) {
			Element xEl = p_xEvent.addElement("event");
			xEl.add(oEntry);
		}
	}	
}