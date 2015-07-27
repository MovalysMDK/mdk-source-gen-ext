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
package com.adeuza.movalysfwk.mf4mdd.ios.xmodele;

import java.util.List;

import com.a2a.adjava.languages.ios.xmodele.MIOSClass;
import com.a2a.adjava.languages.ios.xmodele.MIOSImportDelegate;
import com.a2a.adjava.languages.ios.xmodele.MIOSModeleFactory;
import com.a2a.adjava.languages.ios.xmodele.MIOSPage;
import com.a2a.adjava.languages.ios.xmodele.controllers.MIOS2DListViewController;
import com.a2a.adjava.languages.ios.xmodele.controllers.MIOSComboViewController;
import com.a2a.adjava.languages.ios.xmodele.controllers.MIOSFixedListViewController;
import com.a2a.adjava.languages.ios.xmodele.controllers.MIOSFormViewController;
import com.a2a.adjava.languages.ios.xmodele.controllers.MIOSListViewController;
import com.a2a.adjava.languages.ios.xmodele.controllers.MIOSSearchViewController;
import com.a2a.adjava.languages.ios.xmodele.controllers.MIOSViewController;
import com.a2a.adjava.uml.UmlClass;
import com.a2a.adjava.uml.UmlStereotype;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.MLabel;
import com.a2a.adjava.xmodele.MPackage;
import com.a2a.adjava.xmodele.MPage;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.MStereotype;
import com.a2a.adjava.xmodele.MViewModelImpl;
import com.a2a.adjava.xmodele.XModele;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelType;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoader;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoaderInterface;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelFactory;
import com.adeuza.movalysfwk.mf4mdd.ios.extractor.MF4ITypes;

/**
 * Ios model factory
 *
 */
public class MF4IModelFactory extends MIOSModeleFactory implements MFModelFactory {

	/**
	 * Model factory delegate
	 */
	private MF4IModelFactoryDlg modelFactoryDlg = new MF4IModelFactoryDlg();
	
	/**
	 * XModele factory
	 * @return new XModele instance
	 */
	public XModele<?> createXModele() {
		return new XModele<MF4IDictionnary>( new MF4IDictionnary());
	}
	
	/**
	 * {@inheritDoc}
	 * @see com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelFactory#createDataLoaderInterface(java.lang.String, java.lang.String, com.a2a.adjava.xmodele.MPackage)
	 */
	@Override
	public MDataLoaderInterface createDataLoaderInterface(String p_sUmlName,
			String p_sName, MPackage p_oPackage) {
		return this.modelFactoryDlg.createDataLoaderInterface(p_sUmlName, p_sName, p_oPackage);
	}

	/**
	 * {@inheritDoc}
	 * @see com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelFactory#createDataLoader(java.lang.String, java.lang.String, com.a2a.adjava.xmodele.MPackage, com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoaderInterface)
	 */
	@Override
	public MDataLoader createDataLoader(String p_sUmlName, String p_sName,
			MPackage p_oPackage, MDataLoaderInterface p_oMDataLoaderInterface) {
		return this.modelFactoryDlg.createDataLoader(p_sUmlName, p_sName, p_oPackage, p_oMDataLoaderInterface);
	}
	
	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.languages.android.xmodele.MAndroidModeleFactory#createViewModel(java.lang.String, java.lang.String, com.a2a.adjava.xmodele.MPackage, com.a2a.adjava.xmodele.ui.viewmodel.ViewModelType, com.a2a.adjava.types.ITypeDescription)
	 */
	public MViewModelImpl createViewModel(String p_sName, String p_sUmlName, MPackage p_oPackage, ViewModelType p_sType, MEntityImpl p_oEntityToUpdate, String p_sPath, boolean p_bCustomizable) {
		return this.modelFactoryDlg.createViewModel(p_sName, p_sUmlName, p_oPackage, p_sType, p_oEntityToUpdate, p_sPath, p_bCustomizable);
	}
	
	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.languages.ios.xmodele.MIOSModeleFactory#createFormViewController(java.lang.String,java.lang.String,boolean)
	 */
	@Override
	public MIOSFormViewController createFormViewController( String p_sName, String p_sFormName, List<String> p_listSaveActionNames ) {
		MIOSFormViewController r_oMIOSController = super.createFormViewController(p_sName, p_sFormName, p_listSaveActionNames);
		
		MIOSClass oMIOSClass = new MIOSClass();
		oMIOSClass.setName(p_sName);
		oMIOSClass.setDoGeneration(true);
		oMIOSClass.setSuperClassName(MF4ITypes.MFFormViewController.name());

		r_oMIOSController.setCustomClass(oMIOSClass);
		
		return r_oMIOSController ;
	}
	
	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.languages.ios.xmodele.MIOSModeleFactory#createFormViewController(java.lang.String,java.lang.String,boolean)
	 */
	@Override
	public MIOSSearchViewController createSearchViewController( String p_sName, String p_sFormName, List<String> p_listSaveActionNames ) {
		MIOSSearchViewController r_oMIOSController = super.createSearchViewController(p_sName, p_sFormName, p_listSaveActionNames);
		
		MIOSClass oMIOSClass = new MIOSClass();
		oMIOSClass.setName(p_sName);
		oMIOSClass.setDoGeneration(true);
		oMIOSClass.setSuperClassName(MF4ITypes.MFSearchViewController.name());

		r_oMIOSController.setCustomClass(oMIOSClass);
		
		return r_oMIOSController ;
	}
	
	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.languages.ios.xmodele.MIOSModeleFactory#createFixedListViewController(java.lang.String,java.lang.String,boolean)
	 */
	@Override
	public MIOSFixedListViewController createFixedListViewController( String p_sName, String p_sFormName ) {
		MIOSFixedListViewController r_oMIOSController = super.createFixedListViewController(p_sName, p_sFormName);
		
		MIOSClass oMIOSClass = new MIOSClass();
		oMIOSClass.setName(p_sName);
		oMIOSClass.setDoGeneration(true);
		oMIOSClass.setSuperClassName(MF4ITypes.MFDetailFormViewController.name());

		r_oMIOSController.setCustomClass(oMIOSClass);
		r_oMIOSController.setCellClassName(p_sFormName );
		
		return r_oMIOSController ;
	}
	
	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.languages.ios.xmodele.MIOSModeleFactory#createListViewController(java.lang.String,java.lang.String,boolean)
	 */
	@Override
	public MIOSListViewController createListViewController( String p_sName, String p_sFormName ) {
		MIOSListViewController r_oMIOSController = super.createListViewController(p_sName, p_sFormName);
		
		MIOSClass oMIOSClass = new MIOSClass();
		oMIOSClass.setName(p_sName);
		oMIOSClass.setDoGeneration(true);
		oMIOSClass.setSuperClassName(MF4ITypes.MFListViewController.name());

		r_oMIOSController.setCustomClass(oMIOSClass);
		r_oMIOSController.setCellClassName( p_sFormName + "Cell");
		
		return r_oMIOSController ;
	}
	
	
	
	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.languages.ios.xmodele.MIOSModeleFactory#createFixedListViewController(java.lang.String,java.lang.String,boolean)
	 */
	@Override
	public MIOSComboViewController createComboViewController( String p_sName, String p_sFormName ) {
		MIOSComboViewController r_oMIOSController = super.createComboViewController(p_sName, p_sFormName);
		
		MIOSClass oMIOSClass = new MIOSClass();
		oMIOSClass.setName(p_sName);
		oMIOSClass.setDoGeneration(false);
		oMIOSClass.setSuperClassName(MF4ITypes.MFDetailFormViewController.name());

		r_oMIOSController.setCustomClass(oMIOSClass);
		r_oMIOSController.setSelectedItemCellClassName(p_sFormName + "SelectedItem");
		r_oMIOSController.setItemCellClassName(p_sFormName + "ListItem");
		return r_oMIOSController ;
	}
	

	
	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.languages.ios.xmodele.MIOSModeleFactory#createListViewController(java.lang.String,java.lang.String,boolean)
	 */
	@Override
	public MIOS2DListViewController create2DListViewController( String p_sName, String p_sFormName ) {
		MIOS2DListViewController r_oMIOSController = super.create2DListViewController(p_sName, p_sFormName);
		
		MIOSClass oMIOSClass = new MIOSClass();
		oMIOSClass.setName(p_sName);
		oMIOSClass.setDoGeneration(true);
		oMIOSClass.setSuperClassName(MF4ITypes.MF2DListViewController.name());

		r_oMIOSController.setCustomClass(oMIOSClass);
		r_oMIOSController.setCellClassName( p_sFormName + "Cell");
		
		return r_oMIOSController ;
	}
	
	
	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.languages.ios.xmodele.MIOSModeleFactory#createViewController(java.lang.String)
	 */
	@Override
	public MIOSViewController createViewController(String p_sName) {
		MIOSViewController r_oViewController = super.createViewController(p_sName);
		
		MIOSClass oMIOSClass = new MIOSClass();
		oMIOSClass.setName(MF4ITypes.MFViewController.name());
		oMIOSClass.setDoGeneration(false);
		oMIOSClass.setSuperClassName("UIViewController");
		oMIOSClass.addRelationShip( this.createActionRelationShip("genericButtonPressed:"));
		
		r_oViewController.setCustomClass(oMIOSClass);
		
		return r_oViewController ;
	}
	
	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.languages.ios.xmodele.MIOSModeleFactory#createImportDelegate(java.lang.Object)
	 */
	@Override
	public MIOSImportDelegate createImportDelegate(Object p_oDelegator) {
		return new MF4IImportDelegate(p_oDelegator);
	}

	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.languages.ios.xmodele.MIOSModeleFactory#createPage(java.lang.Object)
	 */
	@Override
	public MIOSPage createPage(MScreen p_oParent, IDomain<IModelDictionary, IModelFactory> p_oDomain, String p_sPageName, 
			UmlClass p_oUmlPage, MPackage p_oPackage, MViewModelImpl p_oVmImpl, boolean p_bTitled) {
		// TODO Auto-generated method stub
		MIOSPage oPage = new MIOSPage( p_oParent, p_sPageName, p_oUmlPage, p_oPackage, p_oVmImpl, p_bTitled);

		if(p_oUmlPage.hasStereotype(MIOSPage.MM_IOS_NO_TABLE)) {
			oPage.addStereotype(new MStereotype(MIOSPage.MM_IOS_NO_TABLE, ""));
		}
		return oPage;
	}
	
	@Override
	public MLabel createLabelForFixedList(String p_sBaseName1, String p_sBaseName2, MViewModelImpl p_oParentVm) {
		// for iOS lst is not the the prefix
		String sBase = p_sBaseName1.substring(3);
		// List is the suffix
		sBase = sBase.concat("List");
		return this.createLabel(sBase, p_oParentVm);
	}
}
