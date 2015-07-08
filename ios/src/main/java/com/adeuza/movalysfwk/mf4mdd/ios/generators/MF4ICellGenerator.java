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

import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;

import com.a2a.adjava.generator.core.incremental.AbstractIncrementalGenerator;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.languages.ios.extractors.IOSVMNamingHelper;
import com.a2a.adjava.languages.ios.xmodele.controllers.MIOS2DListViewController;
import com.a2a.adjava.languages.ios.xmodele.controllers.MIOSComboViewController;
import com.a2a.adjava.languages.ios.xmodele.controllers.MIOSController;
import com.a2a.adjava.languages.ios.xmodele.controllers.MIOSControllerType;
import com.a2a.adjava.languages.ios.xmodele.controllers.MIOSFixedListViewController;
import com.a2a.adjava.languages.ios.xmodele.controllers.MIOSListViewController;
import com.a2a.adjava.languages.ios.xmodele.views.MIOSSection;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.utils.FileTypeUtils;
import com.a2a.adjava.utils.JaxbUtils;
import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.ios.xmodele.MF4IDictionnary;
import com.adeuza.movalysfwk.mf4mdd.ios.xmodele.MF4IDomain;
import com.adeuza.movalysfwk.mf4mdd.ios.xmodele.MF4IModelFactory;

/**
 * Generate cell class for list item
 * @author lmichenaud
 *
 */
public class MF4ICellGenerator extends AbstractIncrementalGenerator<MF4IDomain<MF4IDictionnary, MF4IModelFactory>>{

	/**
	 * Logger for this class
	 */
	private static final Logger log = LoggerFactory.getLogger(MF4ICellGenerator.class);

	/**
	 * Package for controllers
	 */
	private static final String CELL_PACKAGE = "cells";

	/**
	 * Package for controllers
	 */
	private static final String VIEW_PACKAGE = "view";

	/**
	 * Xsl template for cell interface
	 */
	private static final String CELL_LISTITEM_INTERFACE_TEMPLATE = "cell-listitem-interface.xsl";
	
	/**
	 * Xsl template for selected item interface
	 */
	private static final String CELL_SELECTEDITEMCOMBO_INTERFACE_TEMPLATE = "cell-selecteditem-combo-interface.xsl";
	
	/**
	 * Xsl template for item interface
	 */
	private static final String CELL_ITEMCOMBO_INTERFACE_TEMPLATE = "cell-itemcombo-interface.xsl";

	/**
	 * Xsl template for cell implementation
	 */
	private static final String CELL_LISTITEM_IMPL_TEMPLATE = "cell-listitem-impl.xsl";
	
	/**
	 * Xsl template for selected item implementation
	 */
	private static final String CELL_SELECTEDITEMCOMBO_IMPL_TEMPLATE = "cell-selecteditem-combo-impl.xsl";
	
	/**
	 * Xsl template for item implementation
	 */
	private static final String CELL_ITEMCOMBO_IMPL_TEMPLATE = "cell-itemcombo-impl.xsl";

	/**
	 * Xsl template for cell interface
	 */
	private static final String VIEW_EXPANDABLELISTITEM_INTERFACE_TEMPLATE = "view-expandablelistitem-interface.xsl";

	/**
	 * Xsl template for cell implementation
	 */
	private static final String VIEW_EXPANDABLELISTITEM_IMPL_TEMPLATE = "view-expandablelistitem-impl.xsl";

	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.generators.ResourceGenerator#genere(com.a2a.adjava.xmodele.XProject, com.a2a.adjava.generators.DomainGeneratorContext)
	 */
	@Override
	public void genere(
			XProject<MF4IDomain<MF4IDictionnary, MF4IModelFactory>> p_oMProject,
			DomainGeneratorContext p_oGeneratorContext) throws Exception {

		log.debug("> MF4ICellGenerator.genere");
		Chrono oChrono = new Chrono(true);
		MF4IDictionnary oDictionnary = p_oMProject.getDomain().getDictionnary();

		for( MIOSController oController : oDictionnary.getAllIOSControllers()) {
			log.debug("> MF4ICellGenerator.genere {} " , oController.getControllerType() );
			Document xDoc = null;
			String sClassName = null ;
			//Permet de conditionner la création des fichiers associés à la cellule 
			boolean bDoCellGeneration = true;

			if ( oController.getControllerType().equals(MIOSControllerType.LISTVIEW )) {
				MIOSListViewController oListViewController = (MIOSListViewController) oController;
				xDoc = JaxbUtils.marshalToDocument(oListViewController);
				sClassName = oListViewController.getCellClassName();
				this.createCell(xDoc, sClassName, p_oMProject, p_oGeneratorContext, oListViewController);
			} 
			else if ( oController.getControllerType().equals(MIOSControllerType.LISTVIEW2D )) {
				MIOS2DListViewController oListViewController = (MIOS2DListViewController) oController;
				List<MIOSSection> oSectionList = new ArrayList<MIOSSection>(oListViewController.getSections());
				int iSectionIndex = 0;
				for(MIOSSection oSection : oSectionList) {
					oListViewController.removeAllSections();
					oListViewController.addSection(oSection);
					xDoc = JaxbUtils.marshalToDocument(oListViewController);
					sClassName = IOSVMNamingHelper.getInstance().computeViewNameOfExpandableListSection(oListViewController, oSection);
					if(iSectionIndex == 0) {
						this.createView(xDoc, sClassName, p_oMProject, p_oGeneratorContext, oListViewController);
					} else {
						this.createCell(xDoc, sClassName, p_oMProject, p_oGeneratorContext, oListViewController);
					}
					iSectionIndex++;
				}
				oListViewController.removeAllSections();
				oListViewController.setSections(oSectionList);
			}
			else if (oController.getControllerType().equals(MIOSControllerType.FIXEDLISTVIEW )) {
				MIOSFixedListViewController oListViewController = (MIOSFixedListViewController) oController;
				xDoc = JaxbUtils.marshalToDocument(oListViewController);
				sClassName = oListViewController.getCellClassName();
				//Est ce que cette cellule doit étre générée ?
				bDoCellGeneration = oListViewController.isDoCellGeneration();
				if(bDoCellGeneration) {
					this.createCell(xDoc, sClassName, p_oMProject, p_oGeneratorContext, oListViewController);
				}
			}
			else if (oController.getControllerType().equals(MIOSControllerType.COMBOVIEW )) {
				//Ceci crée les deux nouvelles cellules
				MIOSComboViewController oComboViewController = (MIOSComboViewController) oController;
				this.createCellForCombo(oComboViewController, p_oMProject, p_oGeneratorContext);
			}

		}
		log.debug("< MF4ICellGenerator.genere: {}", oChrono.stopAndDisplay());
	}

	/**
	 * Creates a cell class
	 * @param p_oDocument xml document to use 
	 * @param p_sClassName view class name
	 * @param p_oMProject project to use
	 * @param p_oGeneratorContext generator context
	 * @param p_oListViewController list view controller
	 * @throws Exception exception
	 */
	private void createCell(Document p_oDocument, String p_sClassName, 
			XProject<MF4IDomain<MF4IDictionnary, MF4IModelFactory>> p_oMProject, DomainGeneratorContext p_oGeneratorContext, 
			MIOSController p_oListViewController) throws Exception {
		if(p_oDocument != null && p_sClassName != null) {
			this.createCellInterface(p_oDocument, p_sClassName, p_oMProject, p_oGeneratorContext);
			
			// On récupère le document à partir du p_oListViewController car le dernier a été modifié
			// par la méthode précédente
			Document oDocument = JaxbUtils.marshalToDocument(p_oListViewController);
			this.createCellImplementation(oDocument, p_sClassName, p_oMProject, p_oGeneratorContext);
		}
	}

	/**
	 * Create a view class
	 * @param p_oDocument xml document to use 
	 * @param p_sClassName view class name
	 * @param p_oMProject project to use
	 * @param p_oGeneratorContext generator context
	 * @param p_oListViewController list view controller
	 * @throws Exception exception
	 */
	private void createView(Document p_oDocument, String p_sClassName, 
			XProject<MF4IDomain<MF4IDictionnary, MF4IModelFactory>> p_oMProject, DomainGeneratorContext p_oGeneratorContext, 
			MIOSListViewController p_oListViewController) throws Exception {
		if(p_oDocument != null && p_sClassName != null) {
			this.createViewInterface(p_oDocument, p_sClassName, p_oMProject, p_oGeneratorContext);
			
			// On récupère le document à partir du p_oListViewController car le dernier a été modifié
			// par la méthode précédente
			Document oDocument = JaxbUtils.marshalToDocument(p_oListViewController);
			this.createViewImplementation(oDocument, p_sClassName, p_oMProject, p_oGeneratorContext);
		}
	}

		
		/**
		 * Generate cell interface and implementation for the two new cell class necessary for a picker list
		 * @param p_oComboViewController controller
		 * @param p_oMProject project
		 * @param p_oGeneratorContext generator context
		 * @throws Exception exception
		 */
		protected void createCellForCombo(MIOSComboViewController p_oComboViewController,
				XProject<MF4IDomain<MF4IDictionnary, MF4IModelFactory>> p_oMProject, DomainGeneratorContext p_oGeneratorContext) 
						throws Exception{


			if(p_oComboViewController.isSelectedItem())
			{

				//Creation de la cellule pour l'item sélectionné du picker list
				Document xDoc = JaxbUtils.marshalToDocument(p_oComboViewController);
				this.createCellImplementationForSelectedItemOfCombo(xDoc, p_oComboViewController.getSelectedItemCellClassName(), p_oMProject, p_oGeneratorContext);
				
				xDoc = JaxbUtils.marshalToDocument(p_oComboViewController);
				this.createCellInterfaceForSelectedItemOfCombo(xDoc, p_oComboViewController.getSelectedItemCellClassName(), p_oMProject, p_oGeneratorContext);
			}
			else
			{
				//Creation de la cellule pour l'item de liste du picker list
				Document xDoc = JaxbUtils.marshalToDocument(p_oComboViewController);
				this.createCellImplementationForItemOfCombo(xDoc, p_oComboViewController.getItemCellClassName(), p_oMProject, p_oGeneratorContext);
				
				xDoc = JaxbUtils.marshalToDocument(p_oComboViewController);
				this.createCellInterfaceForItemOfCombo(xDoc, p_oComboViewController.getItemCellClassName(), p_oMProject, p_oGeneratorContext);
			}
		}
		
	/**
	 * Generate cell interface
	 * @param p_xController xml of controller
	 * @param p_oCellClassName cell class name
	 * @param p_oMProject project
	 * @param p_oContext generator context
	 * @throws Exception exception
	 */
	protected void createCellInterface( Document p_xController, String p_oCellClassName,
			XProject<MF4IDomain<MF4IDictionnary, MF4IModelFactory>> p_oMProject, DomainGeneratorContext p_oContext) throws Exception {

		String sFile = FileTypeUtils.computeFilenameForIOSInterface(CELL_PACKAGE, p_oCellClassName, p_oMProject.getSourceDir());

		log.debug("  generate file: {}", sFile);
		this.doIncrementalTransform(CELL_LISTITEM_INTERFACE_TEMPLATE, sFile, p_xController, p_oMProject, p_oContext);
	}

	/**
	 * Generate cell implementation
	 * @param p_xController xml of controller 
	 * @param p_oCellClassName cell class name 
	 * @param p_oMProject project
	 * @param p_oContext generator context
	 * @throws Exception exception
	 */
	protected void createCellImplementation( Document p_xController, String p_oCellClassName,
			XProject<MF4IDomain<MF4IDictionnary, MF4IModelFactory>> p_oMProject, DomainGeneratorContext p_oContext) throws Exception {

		String sFile = FileTypeUtils.computeFilenameForIOSImpl(CELL_PACKAGE, p_oCellClassName, p_oMProject.getSourceDir());

		log.debug("  generate file: {}", sFile);
		this.doIncrementalTransform(CELL_LISTITEM_IMPL_TEMPLATE, sFile, p_xController, p_oMProject, p_oContext);
	}

	/**
	 * Generate cell interface
	 * @param p_xController xml of controller
	 * @param p_oViewClassName view class name
	 * @param p_oMProject project
	 * @param p_oContext generator context
	 * @throws Exception exception
	 */
	protected void createViewInterface( Document p_xController, String p_oViewClassName,
			XProject<MF4IDomain<MF4IDictionnary, MF4IModelFactory>> p_oMProject, DomainGeneratorContext p_oContext) throws Exception {

		String sFile = FileTypeUtils.computeFilenameForIOSInterface(VIEW_PACKAGE, p_oViewClassName, p_oMProject.getSourceDir());

		log.debug("  generate file: {}", sFile);
		this.doIncrementalTransform(VIEW_EXPANDABLELISTITEM_INTERFACE_TEMPLATE, sFile, p_xController, p_oMProject, p_oContext);
	}

	/**
	 * Generate cell implementation
	 * @param p_xController xml of controller 
	 * @param p_oViewClassName view class name 
	 * @param p_oMProject project
	 * @param p_oContext generator context
	 * @throws Exception exception
	 */
	protected void createViewImplementation( Document p_xController, String p_oViewClassName,
			XProject<MF4IDomain<MF4IDictionnary, MF4IModelFactory>> p_oMProject, DomainGeneratorContext p_oContext) throws Exception {

		String sFile = FileTypeUtils.computeFilenameForIOSImpl(VIEW_PACKAGE, p_oViewClassName, p_oMProject.getSourceDir());

		log.debug("  generate file: {}", sFile);
		this.doIncrementalTransform(VIEW_EXPANDABLELISTITEM_IMPL_TEMPLATE, sFile, p_xController, p_oMProject, p_oContext);
	}
	
	
	/**
	 * Generate cell interface for selected item of combo
	 * @param p_xController xml of controller
	 * @param p_oCellClassName cell class name
	 * @param p_oMProject project
	 * @param p_oContext generator context
	 * @throws Exception exception
	 */
	protected void createCellInterfaceForSelectedItemOfCombo( Document p_xController, String p_oCellClassName, 
			XProject<MF4IDomain<MF4IDictionnary, MF4IModelFactory>> p_oMProject, DomainGeneratorContext p_oContext) throws Exception {

		String sFileInterface = FileTypeUtils.computeFilenameForIOSInterface(CELL_PACKAGE, p_oCellClassName, p_oMProject.getSourceDir());
		
		log.debug("  generate file: {}", sFileInterface);
		this.doIncrementalTransform(CELL_SELECTEDITEMCOMBO_INTERFACE_TEMPLATE, sFileInterface, p_xController, p_oMProject, p_oContext);
	}
	
	
	/**
	 * Generate cell interface for item combo
	 * @param p_xController xml of controller
	 * @param p_oCellClassName cell class name
	 * @param p_oMProject project
	 * @param p_oContext generator context
	 * @throws Exception exception
	 */
	protected void createCellInterfaceForItemOfCombo( Document p_xController, String p_oCellClassName, 
			XProject<MF4IDomain<MF4IDictionnary, MF4IModelFactory>> p_oMProject, DomainGeneratorContext p_oContext) throws Exception {

		String sFileInterface = FileTypeUtils.computeFilenameForIOSInterface(CELL_PACKAGE, p_oCellClassName, p_oMProject.getSourceDir());
		
		log.debug("  generate file: {}", sFileInterface);
		this.doIncrementalTransform(CELL_ITEMCOMBO_INTERFACE_TEMPLATE, sFileInterface, p_xController, p_oMProject, p_oContext);
	}
	
	/**
	 * Generate cell implementation for selected item of combo
	 * @param p_xController xml of controller
	 * @param p_oCellClassName cell class name
	 * @param p_oMProject project
	 * @param p_oContext generator context
	 * @throws Exception exception
	 */
	protected void createCellImplementationForSelectedItemOfCombo( Document p_xController, String p_oCellClassName,
			XProject<MF4IDomain<MF4IDictionnary, MF4IModelFactory>> p_oMProject, DomainGeneratorContext p_oContext) throws Exception {

		String sFileImpl = FileTypeUtils.computeFilenameForIOSImpl(CELL_PACKAGE, p_oCellClassName, p_oMProject.getSourceDir());
		
		log.debug("  generate file: {}", sFileImpl);
		this.doIncrementalTransform(CELL_SELECTEDITEMCOMBO_IMPL_TEMPLATE, sFileImpl, p_xController, p_oMProject, p_oContext);
	}
	
	
	/**
	 * Generate cell implementation for item combo
	 * @param p_xController xml of controller
	 * @param p_oCellClassName cell class name
	 * @param p_oMProject project
	 * @param p_oContext generator context
	 * @throws Exception exception
	 */
	protected void createCellImplementationForItemOfCombo( Document p_xController, String p_oCellClassName, 
			XProject<MF4IDomain<MF4IDictionnary, MF4IModelFactory>> p_oMProject, DomainGeneratorContext p_oContext) throws Exception {

		String sFileImpl = FileTypeUtils.computeFilenameForIOSImpl(CELL_PACKAGE, p_oCellClassName, p_oMProject.getSourceDir());
		
		log.debug("  generate file: {}", sFileImpl);
		this.doIncrementalTransform(CELL_ITEMCOMBO_IMPL_TEMPLATE, sFileImpl, p_xController, p_oMProject, p_oContext);
	}


}
