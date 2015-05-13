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

import java.util.Collection;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.generator.core.incremental.AbstractIncrementalGenerator;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.utils.FileTypeUtils;
import com.a2a.adjava.utils.VersionHandler;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MPage;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.commons.utils.Version;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4AEvent;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4AScreen;

public class PanelGenerator extends AbstractIncrementalGenerator<IDomain<IModelDictionary, IModelFactory>> {

	/** Logger pour la classe courante */
	private static final Logger log = LoggerFactory
			.getLogger(PanelGenerator.class);

	@Override
	public void genere(XProject<IDomain<IModelDictionary, IModelFactory>> p_oMProject, DomainGeneratorContext p_oGeneratorContext) throws Exception {
		log.debug("> PanelGenerator.genere");
		
		Chrono oChrono = new Chrono(true);
		
		// if generation is V2.0.0
		if ( Version.GENERATION_V2_0_0.equals(VersionHandler.getGenerationVersion()) ) {
		
			for(MScreen oScreen : p_oMProject.getDomain().getDictionnary().getAllScreens()) {
				// create panel only for complex screens
				if ( oScreen.isMultiPanel() || oScreen.isWorkspace() ) {
					
					for (MPage oPage : oScreen.getPages()) {
						this.createPanel(oPage, oScreen, p_oMProject, p_oGeneratorContext);
					}
					
				}
			}
		}
		
		log.debug("< PanelGenerator.genere: {}", oChrono.stopAndDisplay());
	}

	private void createPanel(MPage p_oPage, MScreen p_oScreen, XProject<IDomain<IModelDictionary, IModelFactory>> p_oMProject, DomainGeneratorContext p_oGeneratorContext) throws Exception {
		
		Element r_xFile = p_oPage.toXml();
		log.debug("  >> adding Element :<master-package>"+p_oMProject.getDomain().getRootPackage()+"</>");
		r_xFile.addElement("master-package").setText(p_oMProject.getDomain().getRootPackage());
		if (p_oScreen.isWorkspace()) {
			r_xFile.addElement("screen-class").setText(p_oScreen.getName());
			r_xFile.addElement("screen-class-fullname").setText(p_oScreen.getFullName());
			r_xFile.addElement("screen-vm-interface").setText(p_oScreen.getViewModel().getMasterInterface().getName());
			r_xFile.addElement("screen-vm-interface-fullname").setText(p_oScreen.getViewModel().getMasterInterface().getFullName());
		}
		if ((p_oScreen instanceof MF4AScreen) && p_oScreen.isWorkspace() && p_oScreen.getMasterPage().equals(p_oPage)) {
			Collection<MF4AEvent> listenEvents =  ((MF4AScreen) p_oScreen).getListenEvents();
			
			Element xEvents = r_xFile.addElement("events");
			for (MF4AEvent oEvent : listenEvents) {
				xEvents.add(oEvent.toXml());
			}
		}
		
		Document xDoc = DocumentHelper.createDocument(r_xFile);
		
		String sFile = FileTypeUtils.computeFilenameForJavaClass(p_oMProject.getSourceDir(), p_oPage.getFullName());
		
		String sModele = "panel.xsl";
		
		log.debug("  generation du fichier: {}", sFile);
		this.doIncrementalTransform(sModele, sFile, xDoc, p_oMProject, p_oGeneratorContext);
		
	}

}
