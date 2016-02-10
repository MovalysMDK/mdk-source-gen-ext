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

import java.io.File;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.AdjavaException;
import com.a2a.adjava.generator.core.append.AbstractAppendGenerator;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.utils.VersionHandler;
import com.a2a.adjava.xmodele.MLayout;
import com.a2a.adjava.xmodele.MVisualField;
import com.a2a.adjava.xmodele.XProject;
import com.a2a.adjava.xmodele.ui.component.MWorkspaceConfig;
import com.adeuza.movalysfwk.mf4mdd.commons.utils.Version;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4ADictionnary;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4ADomain;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4AModeleFactory;

/**
 * @author lmichenaud
 *
 */
public class WorkspaceTabLayoutGenerator extends AbstractAppendGenerator<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> {

	/**
	 * 
	 */
	private static final Logger log = LoggerFactory.getLogger(WorkspaceTabLayoutGenerator.class);
	
	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.generators.ResourceGenerator#genere(com.a2a.adjava.xmodele.XProject, com.a2a.adjava.generators.DomainGeneratorContext)
	 */
	@Override
	public void genere(XProject<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> p_oMProject,
			DomainGeneratorContext p_oGeneratorContext) throws Exception {
		
		log.debug("> WorkspaceTabLayoutGenerator.genere");
		Chrono oChrono = new Chrono(true);
		
		for( MLayout oLayout : p_oMProject.getDomain().getDictionnary().getAllLayouts()) {
			
			for( MVisualField oVisualField : oLayout.getFields()) {
				MWorkspaceConfig oWksConfig =
					oVisualField.getVisualParameter(MWorkspaceConfig.VISUALFIELD_PARAMETER);
				if ( oWksConfig != null && oWksConfig.hasTabs()) {
					this.genereWorkspaceTabLayout( oWksConfig.getMainLayout(), p_oMProject, p_oGeneratorContext);
				}
			}
		}
		
		log.debug("< WorkspaceTabLayoutGenerator.genere: {}", oChrono.stopAndDisplay());
	}

	/**
	 * @param p_sMainLayout
	 * @param p_oMProject
	 * @param p_oGeneratorContext
	 * @throws Exception
	 */
	private void genereWorkspaceTabLayout(String p_sMainLayout,
			XProject<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> p_oMProject, DomainGeneratorContext p_oGeneratorContext) throws Exception {
		String sLayoutFileName = p_sMainLayout + ".xml" ;
		if ( sLayoutFileName.length() > 100 ) {
			throw new AdjavaException("File name max length is 100 characters : {} ({})", sLayoutFileName, sLayoutFileName.length());
		}
				
		File oTargetFile = new File(p_oMProject.getLayoutDir(), sLayoutFileName);

		Element xRoot = DocumentHelper.createElement("workspace-tab-layout");
		Document xDoc = DocumentHelper.createDocument(xRoot);
		xRoot.addElement("layout").setText(p_sMainLayout);
		log.debug("  generate file: {}", oTargetFile);
	
		if (Version.GENERATION_V2_0_0.equals(VersionHandler.getGenerationVersion())) {
			log.debug("  <<<< V2");
			this.doAppendGeneration(xDoc, "ui/layout/workspace-tab.xsl", oTargetFile, p_oMProject, p_oGeneratorContext);
		} else {
			log.debug("  <<<< V1");
			this.doAppendGeneration(xDoc, "ui/layout/workspace-tab-v1.0.0.xsl", oTargetFile, p_oMProject, p_oGeneratorContext);
		}
		
		
	}
}
