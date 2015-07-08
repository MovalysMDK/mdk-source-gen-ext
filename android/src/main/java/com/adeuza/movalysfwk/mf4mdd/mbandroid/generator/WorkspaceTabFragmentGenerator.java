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

import com.a2a.adjava.generator.core.incremental.AbstractIncrementalGenerator;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.utils.FileTypeUtils;
import com.a2a.adjava.utils.VersionHandler;
import com.a2a.adjava.xmodele.MLayout;
import com.a2a.adjava.xmodele.MPackage;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.MVisualField;
import com.a2a.adjava.xmodele.XProject;
import com.a2a.adjava.xmodele.ui.component.MWorkspaceConfig;
import com.adeuza.movalysfwk.mf4mdd.commons.utils.Version;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.utils.FragmentNameUtils;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4ADictionnary;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4ADomain;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4AModeleFactory;

/**
 * @author lmichenaud
 *
 */
public class WorkspaceTabFragmentGenerator extends AbstractIncrementalGenerator<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> {

	/**
	 * 
	 */
	private static final Logger log = LoggerFactory.getLogger(WorkspaceTabFragmentGenerator.class);
	
	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.generators.ResourceGenerator#genere(com.a2a.adjava.xmodele.XProject, com.a2a.adjava.generators.DomainGeneratorContext)
	 */
	@Override
	public void genere(XProject<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> p_oMProject,
			DomainGeneratorContext p_oGeneratorContext) throws Exception {
		
		log.debug("> WorkspaceTabFragmentGenerator.genere");
		Chrono oChrono = new Chrono(true);
		
		// if generation is V2.0.0
		if ( Version.GENERATION_V2_0_0.equals( VersionHandler.getGenerationVersion() ) ) {
				
			for( MScreen oScreen : p_oMProject.getDomain().getDictionnary().getAllScreens() ) {
				MLayout oLayout = oScreen.getLayout();
				for( MVisualField oVisualField : oLayout.getFields()) {
					MWorkspaceConfig oWksConfig =
						oVisualField.getVisualParameter(MWorkspaceConfig.VISUALFIELD_PARAMETER);
					if ( oWksConfig != null && oWksConfig.hasTabs()) {
						this.genereWorkspaceTabFragment(oScreen, oWksConfig.getMainLayout(), p_oMProject, p_oGeneratorContext);
					}
				}
			}
			
		}
		log.debug("< WorkspaceTabFragmentGenerator.genere: {}", oChrono.stopAndDisplay());
	}

	/**
	 * @param p_sMainLayout
	 * @param p_oMProject
	 * @param p_oGeneratorContext
	 * @throws Exception
	 */
	private void genereWorkspaceTabFragment(MScreen p_oScreen, String p_sMainLayout,
			XProject<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> p_oMProject, DomainGeneratorContext p_oGeneratorContext) throws Exception {

		MPackage oPanelPackage = new MPackage("panel", p_oScreen.getPackage().getParent());
		
		String sFragmentClassName = FragmentNameUtils.generateFragmentNameFromLayout(p_sMainLayout);
		
		String sFile = FileTypeUtils.computeFilenameForJavaClass(p_oMProject.getSourceDir(), oPanelPackage.getFullName()+"."+sFragmentClassName);
		
		Element xRoot = this.generateXDoc(sFragmentClassName, p_sMainLayout, oPanelPackage, p_oMProject);
		
		Document xDoc = DocumentHelper.createDocument(xRoot);
		log.debug("  generate file: {}", sFile);
	
		String sModele = "panel-workspace-tab.xsl";
		this.doIncrementalTransform(sModele , sFile, xDoc, p_oMProject, p_oGeneratorContext);
	}

	private Element generateXDoc(String p_sFragmentClassName, String p_sMainLayout, MPackage oPanelPackage, XProject<MF4ADomain<MF4ADictionnary,MF4AModeleFactory>> p_oMProject) {
		
		Element xRoot = DocumentHelper.createElement("page");
		
		xRoot.addElement("uml-name").setText(p_sFragmentClassName);
		xRoot.addElement("uml-name-u").setText(p_sFragmentClassName);
		xRoot.addElement("parameters");
		xRoot.addElement("name").setText(p_sFragmentClassName);
		xRoot.addElement("full-name").setText(p_sFragmentClassName);
		xRoot.addElement("package").setText(oPanelPackage.getFullName());
		xRoot.addElement("identifier").addAttribute("identifier", "false");
		xRoot.addElement("stereotypes");
		xRoot.addElement("master-package").setText(p_oMProject.getDomain().getRootPackage());
		xRoot.addElement("layout").setText(p_sMainLayout);
		
		return xRoot;
	}
}
