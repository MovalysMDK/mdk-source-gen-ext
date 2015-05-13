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
package com.adeuza.movalysfwk.mf4mdd.html5.xmodele;

import org.apache.commons.lang3.StringUtils;

import com.a2a.adjava.languages.html5.xmodele.MH5ModeleFactory;
import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.MPackage;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.MViewModelImpl;
import com.a2a.adjava.xmodele.XModele;
import com.a2a.adjava.xmodele.ui.navigation.MNavigation;
import com.a2a.adjava.xmodele.ui.navigation.MNavigationType;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelType;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoader;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoaderInterface;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelFactory;

public class MF4HModelFactory extends MH5ModeleFactory implements MFModelFactory {

	/**
	 * Model factory delegate
	 */
	private MF4HModelFactoryDlg modelFactoryDlg = new MF4HModelFactoryDlg();
	
	/**
	 * @return
	 */
	public XModele<?> createXModele() {
		return new XModele<MF4HDictionary>( new MF4HDictionary());
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
	 * @see com.a2a.adjava.xmodele.IModelFactory#createNavigation(java.lang.String, com.a2a.adjava.xmodele.ui.navigation.MNavigationType, com.a2a.adjava.xmodele.MScreen, com.a2a.adjava.xmodele.MScreen)
	 */
	@Override
	public MNavigation createNavigation(String p_sNavigationName, MNavigationType p_oNavigationType, MScreen p_oScreen,	MScreen p_oScreenEnd) {
		return new MF4HNavigation(p_sNavigationName, p_oNavigationType, p_oScreen, p_oScreenEnd);
	}
	
	@Override
	public String createVisualFieldNameForFixedListCombo(
			MViewModelImpl p_oViewModel, String p_sTName) {
		
		return StringUtils.join(createVmAttributeNameForCombo(p_oViewModel),"_selectedItem", "_", p_sTName);
	}
	
	@Override
	public String createVmAttributeNameForCombo(MViewModelImpl p_oViewModel) {
		
		String r_sAttrName = null;
		if ( p_oViewModel.getMasterInterface().getName().startsWith("VM")) {
			r_sAttrName = "vm" + p_oViewModel.getMasterInterface().getName().substring(2);
		}
		else {
			r_sAttrName = StringUtils.uncapitalize(p_oViewModel.getMasterInterface().getName());
		}
		
		return r_sAttrName;
	}
	
	@Override
	public String createPropertyNameForFixedListCombo(
			MViewModelImpl p_oViewModel, String p_sAttrName) {
		
		return createVmAttributeNameForCombo(p_oViewModel) + "." + p_sAttrName;
	}
	
	/*@Override
	public String createLabelName(String p_sBaseName, MViewModelImpl p_oViewModelImpl) {
		System.out.println("createLabelName: " + p_sBaseName);
		if ( p_sBaseName.equals("nomcourt") ) {
			throw new AdjavaRuntimeException("");
		}
		return p_sBaseName + ".label";
	}
	
	@Override
	public String createLabelNameFromVisualField(String p_sPath,
			MVisualField p_oVisualField) {
		return super.createLabelNameFromVisualField(p_sPath, p_oVisualField).replaceAll("__", ".").replace("_", ".");
	}*/
}
