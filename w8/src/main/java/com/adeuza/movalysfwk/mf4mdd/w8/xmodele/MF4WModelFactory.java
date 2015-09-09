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
package com.adeuza.movalysfwk.mf4mdd.w8.xmodele;

import org.apache.commons.lang3.StringUtils;

import com.a2a.adjava.languages.w8.xmodele.MW8ModeleFactory;
import com.a2a.adjava.uml.UmlClass;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.MLabel;
import com.a2a.adjava.xmodele.MPackage;
import com.a2a.adjava.xmodele.MPage;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.MViewModelImpl;
import com.a2a.adjava.xmodele.MVisualField;
import com.a2a.adjava.xmodele.XModele;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelType;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoader;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoaderInterface;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelFactory;

public class MF4WModelFactory extends MW8ModeleFactory implements MFModelFactory {

	/**
	 * Model factory delegate
	 */
	private MF4WModelFactoryDlg modelFactoryDlg = new MF4WModelFactoryDlg();
	
	/**
	 * @return
	 */
	public XModele<?> createXModele() {
		return new XModele<MF4WDictionary>( new MF4WDictionary());
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
	 * @see com.a2a.adjava.xmodele.IModelFactory#createViewModel(java.lang.String, java.lang.String, com.a2a.adjava.xmodele.MPackage, com.a2a.adjava.xmodele.ui.viewmodel.ViewModelType, com.a2a.adjava.types.ITypeDescription, java.lang.String, boolean)
	 */
	@Override
	public MViewModelImpl createViewModel(String p_sName, String p_sUmlName, MPackage p_oPackage, ViewModelType p_oType, 
			MEntityImpl p_oEntityToUpdate, String p_sPathToModel, boolean p_bCustomizable) {
		return this.modelFactoryDlg.createViewModel(p_sName, p_sUmlName, p_oPackage, p_oType, p_oEntityToUpdate, p_sPathToModel, p_bCustomizable);
	}
	
	@Override
	public MPage createPage(MScreen p_oParent,
			IDomain<IModelDictionary, IModelFactory> p_oDomain,
			String p_sPageName, UmlClass p_oUmlPage, MPackage p_oPackage,
			MViewModelImpl p_oVmImpl, boolean p_bTitled) {
		return new MF4WPage( p_oParent, p_sPageName, p_oUmlPage, p_oPackage, p_oVmImpl, p_bTitled);
	}
	
	@Override
	public String createPropertyNameForFixedListCombo(
			MViewModelImpl p_oViewModel, String p_sAttrName) {
		
		String sAttrCapitalized = StringUtils.capitalize(p_sAttrName);
		String sPropertyName = StringUtils.join("Selected", createVisualFieldNameForFixedListCombo(p_oViewModel, sAttrCapitalized));
		return sPropertyName.replace(StringUtils.join('_',sAttrCapitalized), StringUtils.join('.',sAttrCapitalized));
	}
	
	@Override
	public String createVmAttributeNameForCombo(
			MViewModelImpl p_oViewModel) {
		return p_oViewModel.getMasterInterface().getName();
	}
	
	@Override
	public String createVisualFieldNameForFixedListCombo(
			MViewModelImpl p_oViewModel, String p_sTName) {
		String baseName = StringUtils.join(p_oViewModel.getParameterValue("baseName"), "Item");
		return StringUtils.join(baseName, "_", p_sTName);
	}
	
	
	@Override
	public MLabel createLabelFromVisualField( String p_sPath, MVisualField p_oVisualField) {
		String labelName = (p_oVisualField.isReadOnly() ? 
				StringUtils.replace(p_oVisualField.getName(), "__value", "__label") : 
				StringUtils.replace(p_oVisualField.getName(), "__edit", "__label"));
		
		String sKey = ( !StringUtils.isEmpty(p_sPath) ? p_sPath+"_" : "") + labelName;
				
		return new MF4WLabel(sKey, sKey);
	}
}
