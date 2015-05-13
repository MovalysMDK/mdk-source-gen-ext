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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;

import com.a2a.adjava.generator.core.XslTemplate;
import com.a2a.adjava.generator.core.xmlmerge.AbstractXmlMergeGenerator;
import com.a2a.adjava.generator.core.xmlmerge.xa.configuration.XaConfFile;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.languages.ios.extractors.MIOSComboDelegate;
import com.a2a.adjava.languages.ios.xmodele.controllers.MIOS2DListViewController;
import com.a2a.adjava.languages.ios.xmodele.controllers.MIOSComboViewController;
import com.a2a.adjava.languages.ios.xmodele.controllers.MIOSController;
import com.a2a.adjava.languages.ios.xmodele.controllers.MIOSControllerType;
import com.a2a.adjava.languages.ios.xmodele.controllers.MIOSFixedListViewController;
import com.a2a.adjava.languages.ios.xmodele.controllers.MIOSListViewController;
import com.a2a.adjava.languages.ios.xmodele.controllers.MIOSViewController;
import com.a2a.adjava.languages.ios.xmodele.views.MIOSEditableView;
import com.a2a.adjava.languages.ios.xmodele.views.MIOSSection;
import com.a2a.adjava.languages.ios.xmodele.views.MIOSView;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.utils.JaxbUtils;
import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.ios.xmodele.MF4IDictionnary;
import com.adeuza.movalysfwk.mf4mdd.ios.xmodele.MF4IDomain;
import com.adeuza.movalysfwk.mf4mdd.ios.xmodele.MF4IModelFactory;

/**
 * Generate configuration files
 *
 */
public class MF4IConfGenerator extends AbstractXmlMergeGenerator<MF4IDomain<MF4IDictionnary, MF4IModelFactory>>{

	/**
	 * Logger
	 */
	private static final Logger log = LoggerFactory.getLogger(MF4IConfGenerator.class);
	

	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.generators.ResourceGenerator#genere(com.a2a.adjava.xmodele.XProject, com.a2a.adjava.generators.DomainGeneratorContext)
	 */
	@Override
	public void genere(
			XProject<MF4IDomain<MF4IDictionnary, MF4IModelFactory>> p_oMProject,
			DomainGeneratorContext p_oGeneratorContext) throws Exception {
		
		log.debug("> MF4IConfGenerator.genere");
		Chrono oChrono = new Chrono(true);
		
		MF4IDictionnary oDictionnary = p_oMProject.getDomain().getDictionnary();

		for( MIOSController oController : oDictionnary.getAllIOSControllers()) {
			if ( oController.getControllerType().equals(MIOSControllerType.LISTVIEW) ) {
				MIOSListViewController oListViewController = (MIOSListViewController) oController;
				Document xDoc = JaxbUtils.marshalToDocument(oListViewController);
				this.createCellConf(xDoc, oListViewController.getCellClassName(), p_oMProject, p_oGeneratorContext);
			}else if ( oController.getControllerType().equals(MIOSControllerType.LISTVIEW2D) ) {
				MIOS2DListViewController oList2DViewController = (MIOS2DListViewController) oController;
				
				Document xDoc = JaxbUtils.marshalToDocument(oList2DViewController);
				this.createCellConf(xDoc, oList2DViewController.getCellClassName(), p_oMProject, p_oGeneratorContext);
				
				//On doit récupérer un xDoc vide marshallé du o2ListViewController (car la méthode précédente l'a modifié)
				xDoc = JaxbUtils.marshalToDocument(oList2DViewController);
				this.createSectionConf(xDoc, oList2DViewController.getSectionFormName(), p_oMProject, p_oGeneratorContext);
			}
			else if ( oController.getControllerType() == MIOSControllerType.FIXEDLISTVIEW) {
				MIOSFixedListViewController oListViewController = (MIOSFixedListViewController) oController;
				Document xDoc = JaxbUtils.marshalToDocument(oListViewController);
				this.createCellConf(xDoc, oListViewController.getCellClassName(), p_oMProject, p_oGeneratorContext);
				createCellConfForPickerList(oListViewController.getSections().get(0), oListViewController, p_oMProject, p_oGeneratorContext);
			}else if ( oController.getControllerType() == MIOSControllerType.COMBOVIEW) {
				MIOSComboViewController oComboViewController = (MIOSComboViewController) oController;
				if(!oComboViewController.isSelectedItem())
				{
					Document xDoc = JaxbUtils.marshalToDocument(oComboViewController);
					this.createCellConf(xDoc, oComboViewController.getItemCellClassName(), p_oMProject, p_oGeneratorContext);
				}
			}else if ( oController.getControllerType() == MIOSControllerType.FORMVIEW) {
				MIOSViewController oViewController = (MIOSViewController) oController;
				for(MIOSSection oCurrentSection : oViewController.getSections())
				{
					createCellConfForPickerList(oCurrentSection, oViewController, p_oMProject, p_oGeneratorContext);
				}
			}
		}

		log.debug("< MF4IConfGenerator.genere: {}", oChrono.stopAndDisplay());
	}
	
	/**
	 * Creates a cell for a picker list
	 * @param p_oSection section to use
	 * @param p_oViewController view controller
	 * @param p_oMProject project
	 * @param p_oGeneratorContext generator context
	 * @throws Exception exception
	 */
	private void createCellConfForPickerList(MIOSSection p_oSection, MIOSViewController p_oViewController,XProject<MF4IDomain<MF4IDictionnary, MF4IModelFactory>> p_oMProject,
			DomainGeneratorContext p_oGeneratorContext) throws Exception {
		for(MIOSView oCurrentView : p_oSection.getSubViews())
		{
			if(oCurrentView instanceof MIOSEditableView && ((MIOSEditableView)oCurrentView).getCellType().equals("MFCellComponentPickerList"))
			{
				MIOSViewController oCloneController = p_oViewController.clone();
				MIOSSection oCloneSection = p_oSection.clone();
				oCloneController.getSections().clear();
				oCloneSection.getSubViews().clear();
				oCloneSection.addSubView(oCurrentView);
				oCloneSection.computeSubviewsPosition();
				
				oCloneController.getSections().add(oCloneSection);
				oCloneController.setControllerType(MIOSControllerType.FORMVIEW);
				Document xDoc = JaxbUtils.marshalToDocument(oCloneController);
				
				String confName = ((MIOSEditableView) oCloneController.getSections().get(0).getSubViews().get(0)).getOptions().get(MIOSComboDelegate.KEY_TO_CELL_SELECTED_ITEM_NAME);
				this.createCellConf(xDoc, confName, p_oMProject, p_oGeneratorContext);
			}
		}
	}
	
	
	/**
	 * Generate cell configuration
	 * @param p_xController xml of controller
	 * @param p_oControllerCellClassName controller cell class name
	 * @param p_oMProject project
	 * @param p_oContext generator context
	 * @throws Exception exception
	 */
	protected void createCellConf( Document p_xController, String p_oControllerCellClassName,
			XProject<MF4IDomain<MF4IDictionnary, MF4IModelFactory>> p_oMProject, DomainGeneratorContext p_oContext) throws Exception {

		StringBuilder oFileName = new StringBuilder();
		oFileName.append("resources/plist/configuration/conf-");
		oFileName.append( p_oControllerCellClassName);
		oFileName.append(".plist");
		
		File oPListFile = new File(oFileName.toString());

		log.debug("  generate file: {}", oPListFile);
		this.doXmlMergeGeneration(p_xController, XslTemplate.CELL_CONF_TEMPLATE, oPListFile, p_oMProject, p_oContext,XaConfFile.IOS_PLIST);
	}
	
	/**
	 * Generate cell configuration
	 * @param p_xController xml of controller
	 * @param p_oSectionName section name
	 * @param p_oMProject project
	 * @param p_oContext generator context
	 * @throws Exception exception
	 */
	protected void createSectionConf( Document p_xController, String p_oSectionName,
			XProject<MF4IDomain<MF4IDictionnary, MF4IModelFactory>> p_oMProject, DomainGeneratorContext p_oContext) throws Exception {

		StringBuilder oFileName = new StringBuilder();
		oFileName.append("resources/plist/configuration/conf-");
		oFileName.append( p_oSectionName);
		oFileName.append(".plist");
		
		File oPListFile = new File(oFileName.toString());

		log.debug("  generate file: {}", oPListFile);
		this.doXmlMergeGeneration(p_xController, XslTemplate.SECTION_CONF_TEMPLATE, oPListFile, p_oMProject, p_oContext,XaConfFile.IOS_PLIST);
	}
}
