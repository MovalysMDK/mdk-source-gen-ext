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
import java.util.HashMap;
import java.util.Map;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.Node;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.AdjavaException;
import com.a2a.adjava.generator.core.append.AbstractAppendGenerator;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.utils.VersionHandler;
import com.a2a.adjava.xmodele.MLayout;
import com.a2a.adjava.xmodele.MPackage;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.MVisualField;
import com.a2a.adjava.xmodele.XProject;
import com.a2a.adjava.xmodele.ui.component.MGridSectionConfig;
import com.a2a.adjava.xmodele.ui.component.MMultiPanelConfig;
import com.a2a.adjava.xmodele.ui.component.MWorkspaceConfig;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelType;
import com.adeuza.movalysfwk.mf4mdd.commons.utils.Version;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.utils.FragmentNameUtils;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4ADictionnary;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4ADomain;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4AModeleFactory;

/**
 * <p>
 * Generate SuperFactory of Dao
 * </p>
 * 
 * <p>
 * Copyright (c) 2011
 * <p>
 * Company: Adeuza
 * 
 * @author emalespine
 * 
 */

public class LayoutGenerator extends AbstractAppendGenerator<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> {

	/**
	 * 
	 */
	private static final Logger log = LoggerFactory.getLogger(LayoutGenerator.class);
	private Map<MWorkspaceConfig, String> savedOldConfig = new HashMap<MWorkspaceConfig,String>();

	/**
	 * Génère l'interface SuperEntityFactory
	 */
	@Override
	public void genere(XProject<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> p_oMProject, DomainGeneratorContext p_oContext) throws Exception {

		log.debug("> LayoutGenerator.genere");
		Chrono oChrono = new Chrono(true);
		
		if ( !p_oMProject.getDomain().getDictionnary().getAllLayouts().isEmpty()) {
			for (MLayout oLayout : p_oMProject.getDomain().getDictionnary().getAllLayouts()) {
				
				// if Generation V2 go with fragments
				if ( Version.GENERATION_V2_0_0.equals( VersionHandler.getGenerationVersion() ) && (oLayout.isWorkspace() || oLayout.isMultiPanel()) ) {
					changeLayoutWithFragment(oLayout, p_oMProject);
				} else if ( Version.GENERATION_V1_0_0.equals( VersionHandler.getGenerationVersion() ) ) {
				}
				
				// Ajout du noeud XML associé à l'interface courante
				Element x = oLayout.toXml();
				
				this.suppressInterfaceButton(x);
				
				
				String sLayoutFileName = oLayout.getName() + ".xml" ;
				
				if ( sLayoutFileName.length() > 100 ) {
					throw new AdjavaException("File name max length is 100 characters : {} ({})",
						sLayoutFileName, sLayoutFileName.length());
				}
				
				File oTargetFile = new File(p_oMProject.getLayoutDir(), sLayoutFileName);
				
				Document xDoc = DocumentHelper.createDocument(x);
				log.debug("  generate layout file {}", oTargetFile.getPath());
				
				this.doAppendGeneration(xDoc, "layout.xsl", oTargetFile, p_oMProject, p_oContext);
			}
		}
		// see for optimisation
		for (MWorkspaceConfig resotreConf : this.savedOldConfig.keySet()) {
			resotreConf.setMainConfig(resotreConf.getViewModelGetter(), this.savedOldConfig.get(resotreConf));
		}
		
		log.debug("< LayoutGenerator.genere: {}", oChrono.stopAndDisplay());
	}

	private void changeLayoutWithFragment(MLayout p_oLayout, XProject<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> p_oMProject) {
		
		for(MVisualField field : p_oLayout.getFields()) {
			// if the field is MultiPanel
			if ( field.getComponent().equals(ViewModelType.MULTIPANEL.getParametersByConfigName(ViewModelType.DEFAULT, VersionHandler.getGenerationVersion().getStringVersion()).getVisualComponentNameFull()) ) {
				MMultiPanelConfig mutiPanelConfig = field.getVisualParameter("multipanel-config");
				
				if ( !mutiPanelConfig.getSectionConfigs().isEmpty()) {
				
					// change the layout by the Fragment Class
					for(MGridSectionConfig panelConfig : mutiPanelConfig.getSectionConfigs()) {
						panelConfig.setLayout(panelConfig.getPage().getFullName());
					}
				}
			}
			// if the field is Workspace
			if ( field.getComponent().equals(ViewModelType.WORKSPACE_MASTERDETAIL.getParametersByConfigName(ViewModelType.DEFAULT, VersionHandler.getGenerationVersion().getStringVersion()).getVisualComponentNameFull()) ||
					field.getComponent().equals(ViewModelType.WORKSPACE_DETAIL.getParametersByConfigName(ViewModelType.DEFAULT, VersionHandler.getGenerationVersion().getStringVersion()).getVisualComponentNameFull()) ) {
				MWorkspaceConfig workspaceConf = field.getVisualParameter("workspace-config");
				// get The main panel...
				if (workspaceConf.getMainPage() != null) {
					workspaceConf.setMainConfig(workspaceConf.getViewModelGetter(), workspaceConf.getMainPage().getFullName());
				} 
				// there is a tab master
				if (!workspaceConf.getTabConfigs().isEmpty()) {
					// we have to store the change for restore at the end because of the WorkspaceTabLayoutGenerator
					this.savedOldConfig.put(workspaceConf, workspaceConf.getMainLayout());
					// gene fragmentName
					String sFragmentName = FragmentNameUtils.generateFragmentNameFromLayout(workspaceConf.getMainLayout());

					MScreen oScreen = findLayoutOwner(p_oLayout, p_oMProject);
					MPackage oPanelPackage = new MPackage("panel", oScreen.getPackage().getParent());
					String sFragmentFullName = oPanelPackage.getFullName() + "." + sFragmentName;
					workspaceConf.setMainConfig(workspaceConf.getViewModelGetter(), sFragmentFullName);
				}
				// change the layout in tab config
				for(MGridSectionConfig tabConfig : workspaceConf.getTabConfigs()) {
					tabConfig.setLayout(tabConfig.getPage().getFullName());
				}
				// change the layout with Fragment class
				for(MGridSectionConfig detailConfig : workspaceConf.getDetailConfigs()) {
					detailConfig.setLayout(detailConfig.getPage().getFullName());
				}
			}
			
		}
	}

	private MScreen findLayoutOwner(MLayout p_oLayout, XProject<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> p_oMProject) {
		MScreen r_oScreen = null;
		for( MScreen oScreen : p_oMProject.getDomain().getDictionnary().getAllScreens()) {
			if ( oScreen.getLayout() == p_oLayout) {
				r_oScreen = oScreen ;
				break;
			}
		}
		return r_oScreen;
	}
	
	private void suppressInterfaceButton(Element x) {
		
		Node oSaveButton = x.selectSingleNode("buttons/button[@type='SAVE']");
		if (oSaveButton != null) {
			oSaveButton.detach();
		}
		
		Node oDeleteButton = x.selectSingleNode("buttons/button[@type='DELETE']");
		if (oDeleteButton != null) {
			oDeleteButton.detach();
		}
		Node oNavButton = x.selectSingleNode("buttons/button[navigation/@type='NAVIGATION_WKS_SWITCHPANEL' or navigation/@type='NAVIGATION_DETAIL']");
		if (oNavButton != null) {
			oNavButton.detach();
		}
	}
}