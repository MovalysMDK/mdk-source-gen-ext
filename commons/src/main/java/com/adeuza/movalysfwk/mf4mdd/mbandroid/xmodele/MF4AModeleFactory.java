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
package com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele;

import java.util.List;

import org.apache.commons.lang3.StringUtils;

import com.a2a.adjava.languages.android.xmodele.MAndroidModeleFactory;
import com.a2a.adjava.types.IUITypeDescription;
import com.a2a.adjava.uml.UmlClass;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MAction;
import com.a2a.adjava.xmodele.MActionInterface;
import com.a2a.adjava.xmodele.MActionType;
import com.a2a.adjava.xmodele.MAdapter;
import com.a2a.adjava.xmodele.MAttribute;
import com.a2a.adjava.xmodele.MDaoInterface;
import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.MLabel;
import com.a2a.adjava.xmodele.MLayout;
import com.a2a.adjava.xmodele.MPackage;
import com.a2a.adjava.xmodele.MPage;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.MViewModelImpl;
import com.a2a.adjava.xmodele.MVisualField;
import com.a2a.adjava.xmodele.XModele;
import com.a2a.adjava.xmodele.XProject;
import com.a2a.adjava.xmodele.ui.component.MMultiPanelConfig;
import com.a2a.adjava.xmodele.ui.menu.MMenu;
import com.a2a.adjava.xmodele.ui.menu.MMenuActionItem;
import com.a2a.adjava.xmodele.ui.menu.MMenuItem;
import com.a2a.adjava.xmodele.ui.navigation.MNavigation;
import com.a2a.adjava.xmodele.ui.navigation.MNavigationType;
import com.a2a.adjava.xmodele.ui.view.MVFLabelKind;
import com.a2a.adjava.xmodele.ui.view.MVFLocalization;
import com.a2a.adjava.xmodele.ui.view.MVFModifier;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelType;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelTypeConfiguration;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoader;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoaderInterface;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelFactory;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelFactoryDlg;

/**
 * @author lmichenaud
 *
 */
public class MF4AModeleFactory extends MAndroidModeleFactory implements MFModelFactory {

	/**
	 * Model factory delegate
	 */
	private MFModelFactoryDlg modelFactoryDlg = new MFModelFactoryDlg();

	/**
	 * @return
	 */
	public XModele<?> createXModele() {
		return new XModele<MF4ADictionnary>( new MF4ADictionnary());
	}

	/**
	 * {@inheritDoc}
	 * @see com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelFactory#createDataLoader(java.lang.String, java.lang.String, com.a2a.adjava.xmodele.MPackage, com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoaderInterface)
	 */
	@Override
	public MDataLoader createDataLoader( String p_sUmlName, String p_sName, MPackage p_oPackage, MDataLoaderInterface p_oMDataLoaderInterface) {
		return this.modelFactoryDlg.createDataLoader(p_sUmlName, p_sName, p_oPackage, p_oMDataLoaderInterface);
	}

	/**
	 * {@inheritDoc}
	 * @see com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelFactory#createDataLoaderInterface(java.lang.String, java.lang.String, com.a2a.adjava.xmodele.MPackage)
	 */
	@Override
	public MDataLoaderInterface createDataLoaderInterface( String p_sUmlName, String p_sName, MPackage p_oPackage) {
		return this.modelFactoryDlg.createDataLoaderInterface(p_sUmlName, p_sName, p_oPackage);
	}

	/**
	 * (non-Javadoc)
	 * @see com.a2a.adjava.xmodele.XModeleFactory#createScreen(java.lang.String, java.lang.String, com.a2a.adjava.xmodele.MPackage)
	 */
	@Override
	public MScreen createScreen(String p_sFullName, String p_sName, MPackage p_oScreenPackage) {
		return new MF4AScreen(p_sFullName, p_sName, p_oScreenPackage);
	}

	@Override
	/**
	 * Create a page
	 * @param p_oParent screen parent
	 * @param p_oDomain 
	 * @param p_sPageName page name
	 * @param p_oUmlPage uml class from which panel is created
	 * @param p_oPackage package
	 * @param p_oVmImpl viewmodel implementation
	 * @param p_bTitled true if panel has title
	 * @return page
	 */
	public MPage createPage(MScreen p_oParent, IDomain<IModelDictionary, IModelFactory> p_oDomain, String p_sPageName,
			UmlClass p_oUmlPage, MPackage p_oPackage, MViewModelImpl p_oVmImpl,
			boolean p_bTitled) {
		XProject oProjet = p_oDomain.getProject("application");
		MPage r_oPage = oProjet.getDomain().getDictionnary().getPanel(p_sPageName);
		if (r_oPage==null) {
			r_oPage = new MF4APage(p_oParent, p_sPageName, p_oUmlPage, p_oPackage, p_oVmImpl, p_bTitled);
		}
		return r_oPage;

		//		return super.createPage(p_oParent, p_sPageName, p_oUmlPage, p_oPackage, p_oVmImpl, p_bTitled);
	}

	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.xmodele.XModeleFactory#createAction(java.lang.String, boolean, com.a2a.adjava.xmodele.MPackage, com.a2a.adjava.xmodele.MActionType, com.a2a.adjava.xmodele.MViewModelImpl, com.a2a.adjava.xmodele.MDaoInterface, java.util.List, java.lang.String)
	 */
	@Override
	public MAction createAction(String p_sName, MActionInterface p_oActionInterface, boolean p_bIsRoot, MPackage p_oPackage, MViewModelImpl p_oViewModel,
			MDaoInterface p_oDao, List<MDaoInterface> p_listExternalDaos, String p_sCreatorName) {
		return new MF4AAction(p_sName, p_oActionInterface, p_bIsRoot, p_oPackage, p_oViewModel, p_oDao, p_listExternalDaos, p_sCreatorName);
	}

	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.xmodele.XModeleFactory#createActionInterface(java.lang.String, boolean, com.a2a.adjava.xmodele.MPackage, java.lang.String, java.lang.String, java.lang.String, java.lang.String, com.a2a.adjava.xmodele.MEntityImpl)
	 */
	@Override
	public MActionInterface createActionInterface(String p_sName, boolean p_bRoot, MPackage p_oPackage, String p_sInNameClass,
			String p_sOutNameClass, String p_sStepClass, String p_sProgressClass, MEntityImpl p_oEntity, MActionType p_oActionType ) {
		return new MF4AActionInterface(p_sName, p_bRoot, p_oPackage, p_sInNameClass, p_sOutNameClass, p_sStepClass, p_sProgressClass,
				p_oEntity, p_oActionType);
	}

	/**
	 * (non-Javadoc)
	 * @see com.a2a.adjava.xmodele.XModeleFactory#createNavigation(java.lang.String, com.a2a.adjava.xmodele.MScreen, com.a2a.adjava.xmodele.MScreen)
	 */
	@Override
	public MNavigation createNavigation(String p_sNavigationName, MNavigationType p_oNavigationType, MScreen p_oScreen, MScreen p_oScreenEnd) {
		return new MF4ANavigation(p_sNavigationName, p_oNavigationType, p_oScreen, p_oScreenEnd);
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
	 * @see com.a2a.adjava.xmodele.IModelFactory#createVisualField(java.lang.String, com.a2a.adjava.types.IUITypeDescription, com.a2a.adjava.xmodele.ui.view.MVFModifier, com.a2a.adjava.xmodele.ui.view.MVFLabelKind, com.a2a.adjava.xmodele.MAttribute, com.a2a.adjava.xmodele.ui.view.MVFLocalization, com.a2a.adjava.xmodele.IDomain, java.lang.String, boolean)
	 */
	@Override
	public MVisualField createVisualField(String p_sPrefix, MLabel p_oLabel, IUITypeDescription p_oTypeVisual,
			MVFModifier p_bMVFModifier, MVFLabelKind p_oLabelKind, MAttribute p_oAttribute,
			MVFLocalization p_oLocalisation, IDomain<IModelDictionary, IModelFactory> p_oDomain,
			String p_sAttributeName, boolean p_bMandatory) {
		return new MF4AVisualField(p_sPrefix + (p_bMVFModifier == MVFModifier.READONLY ? "__value" : "__edit"), p_oLabel,
				p_oTypeVisual.getComponentType(p_bMVFModifier), p_oAttribute.getTypeDesc().getEditType(),
				p_oAttribute.getLength(), p_oAttribute.getPrecision(), p_oAttribute.getScale(),
				p_oLabelKind, p_oLocalisation, p_sAttributeName, p_bMandatory, p_oAttribute.getMEnumeration());
	}

	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.xmodele.IModelFactory#createVisualField(java.lang.String, java.lang.String, java.lang.String, com.a2a.adjava.xmodele.ui.view.MVFLabelKind, com.a2a.adjava.xmodele.ui.view.MVFLocalization, java.lang.String, boolean)
	 */
	@Override
	public MVisualField createVisualField(String p_sName, MLabel p_oLabel, String p_sComponent,
			MVFLabelKind p_oLabelKind, MVFLocalization p_oTarget, String p_sAttributeName,
			boolean p_bMandatoryKind) {
		return new MF4AVisualField(p_sName, p_oLabel, p_sComponent, p_oLabelKind, p_oTarget,
				p_sAttributeName, p_bMandatoryKind);
	}

	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.xmodele.IModelFactory#createVisualField(java.lang.String, java.lang.String, java.lang.String, com.a2a.adjava.xmodele.ui.view.MVFLabelKind, java.lang.String, boolean)
	 */
	@Override
	public MVisualField createVisualField(String p_sName, MLabel p_oLabel, String p_sComponent,
			MVFLabelKind p_oLabelKind, String p_sAttributeName, boolean p_bMandatoryKind) {
		return new MF4AVisualField(p_sName, p_oLabel, p_sComponent, p_oLabelKind, p_sAttributeName,
				p_bMandatoryKind);
	}

	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.xmodele.IModelFactory#createVisualField(java.lang.String, com.a2a.adjava.xmodele.MVisualField)
	 */
	@Override
	public MVisualField createVisualField(String p_sPath, MVisualField p_oField, MLabel p_oLabel) {
		return new MF4AVisualField(p_sPath, p_oField, p_oLabel);
	}

	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.xmodele.XModeleFactory#createMultiPanelConfig()
	 */
	@Override
	public MMultiPanelConfig createMultiPanelConfig() {
		return new MF4AMultiPanelConfig();
	}

	@Override
	public String createVisualFieldNameForFixedListCombo(
			MViewModelImpl p_oViewModel, String p_sTName) {
		return StringUtils.join(p_oViewModel.getParameterValue("baseName"), "_", p_sTName);
	}

	@Override
	public MMenuActionItem createMenuActionItem(String p_sId) {
		return new MF4AMenuActionItem(p_sId);
	}

	@Override
	public MAdapter createExternalAdapter(IDomain<IModelDictionary, IModelFactory> p_oDomain,
			ViewModelTypeConfiguration p_oTypeParameters, MViewModelImpl p_oVm, String p_sBaseName) {
		MAdapter oAdapter = new MAdapter("ConfigurableSpinnerAdapter", 
				new MPackage("com.adeuza.movalysfwk.mobile.mf4android.ui.modele", null),
				p_oTypeParameters.getAdapterName(), 
				p_oTypeParameters.getAdapterFullName());

		return oAdapter;
	}

	public MF4ALabel createLabelFromPrompt( MVisualField p_oVisualField ) {
		String sPromptKey = p_oVisualField.getName().replace("__edit","").replace("__value", "") + "_prompt";
		p_oVisualField.addParameter("prompt", sPromptKey);

		String sDefaultValue = p_oVisualField.getEntityLinkedAttributeName().substring(
				p_oVisualField.getEntityLinkedAttributeName().lastIndexOf('.')+1);
		return new MF4ALabel(sPromptKey, this.createLabelValue(sDefaultValue));
	}

	public MF4ALabel createLabelForLayoutTitle( MLayout p_oLayout) {
		return new MF4ALabel(p_oLayout.getTitle(), this.createLabelValue(p_oLayout.getShortName()));
	}

	public MF4ALabel createLabelForField( MVisualField p_oVisualField) {
		return new MF4ALabel(p_oVisualField.getLabel().getKey(), this.createLabelValue(p_oVisualField.getLabel().getValue()));
	}

	public MF4ALabel createLabelForMenuItem(MMenuItem p_oMenuItem, MMenu p_oMenu, MScreen p_oScreen) {
		StringBuilder sTitle = new StringBuilder("application_menu_");
		sTitle.append(p_oScreen.getName().toLowerCase());
		sTitle.append('_');
		sTitle.append(p_oMenu.getId());
		sTitle.append('_');
		sTitle.append(p_oMenuItem.getNavigation().getTarget().getName().toLowerCase());
		return new MF4ALabel(sTitle.toString(), p_oMenuItem.getNavigation().getTarget().getName());
	}

	public MF4ALabel createLabelForMenuActionItem(MMenuActionItem p_oMenuItem, MMenu p_oMenu, MScreen p_oScreen) {
		StringBuilder sTitle = new StringBuilder("application_actionmenu_");
		sTitle.append(p_oScreen.getName().toLowerCase());

		String sValue = null;
		if (!p_oMenuItem.getActions().isEmpty()) {
			sValue = p_oMenuItem.getActions().get(0).getName().toLowerCase();
		} else {
			sTitle.append('_');
			sTitle.append(p_oMenuItem.getNavigationButton().getName().toLowerCase());
			sValue = p_oMenuItem.getNavigationButton().getName().toLowerCase();
		}

		return new MF4ALabel(sTitle.toString(), sValue);
	}

	@Override
	public MLabel createLabelForScreen(MScreen p_oScreen) {
		String sLabel = createLabelKey(p_oScreen.getName());
		String sValue = createLabelValue(p_oScreen.getName());
		return new MF4ALabel(sLabel, sValue);
	}
}
