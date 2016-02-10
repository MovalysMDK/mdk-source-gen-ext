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

import org.dom4j.Document;

import com.a2a.adjava.languages.ios.generators.VMInterfaceGenerator;
import com.a2a.adjava.languages.ios.xmodele.MIOSImportDelegate;
import com.a2a.adjava.xmodele.MAttribute;
import com.a2a.adjava.xmodele.MViewModelImpl;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelType;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelTypeConfiguration;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFViewModel;
import com.adeuza.movalysfwk.mf4mdd.ios.xmodele.MF4IImportDelegate;

/**
 * Viewmodel interface generator
 * @author lmichenaud
 *
 */
public class MF4IVmInterfaceGenerator extends VMInterfaceGenerator {

	/**
	 * View model has sublist key
	 */
	private static String PARAMETER_VIEWMODEL_HAS_SUBLIST_KEY = "hasSublist";
	
	/**
	 * Protocol class used on view models with sublists
	 */
	private static String IMPORT_VIEW_MODEL_WITH_SUBLIST_PROTOCOL = "MFBaseViewModelWithSublistProtocol";

	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.generator.impl.ViewModelInterfaceGenerator#computeXml(com.a2a.adjava.xmodele.MViewModelImpl)
	 */
	@Override
	protected Document computeXml(MViewModelImpl p_oMViewModel) {
		Document r_xDoc = super.computeXml(p_oMViewModel);
		
		MFViewModel oVm = (MFViewModel) p_oMViewModel;
		
		MF4IImportDelegate oImportDlg = new MF4IImportDelegate(this);
		if (oVm.getEntityToUpdate() != null ) {
			oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.ENTITIES.name(), oVm.getEntityToUpdate().getMasterInterface().getName());
		}

		for(MViewModelImpl oExtVM : oVm.getExternalViewModels())
		{
			oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.VIEWMODEL.name(), oExtVM.getName());
			if ( oExtVM.getType().equals(ViewModelType.LIST_1__ONE_SELECTED )) {
				ViewModelTypeConfiguration oClonedVMTypeConf= ViewModelType.LIST_1__ONE_SELECTED.getVMTypeOptionMap().get(oExtVM.getConfigName());	
				oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.VIEWMODEL.name(), oClonedVMTypeConf.getInterfaceName());
			}
		}

		
		for( MAttribute oAttr : p_oMViewModel.getAttributes()) {
			if ( oAttr.isEnum()) {
				oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.ENTITIES.name(), oAttr.getTypeDesc().getShortName());
			}
		}
		
		for( MViewModelImpl oSubVm : oVm.getSubViewModels()) {
			checkForProtocolImports(oVm, oImportDlg);
			oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.VIEWMODEL.name(), oSubVm.getName());
			for( MViewModelImpl oSubSubVm : oSubVm.getSubViewModels()) {
				checkForProtocolImports(oVm, oImportDlg);
				oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.VIEWMODEL.name(), oSubSubVm.getName());
			}
		}
		
		r_xDoc.getRootElement().add(oImportDlg.toXml());
		
		return r_xDoc ;
	}
	
	/**
	 * Check if protocol imports are present, and adds them if not
	 * @param p_oViewModel view model
	 * @param p_oImportDlg import delegate
	 */
	private void checkForProtocolImports(MViewModelImpl p_oViewModel, MF4IImportDelegate p_oImportDlg) {
		if(p_oViewModel.getParameters().get(PARAMETER_VIEWMODEL_HAS_SUBLIST_KEY) != null ) {
			p_oImportDlg.addImport(MIOSImportDelegate.MIOSImportCategory.VIEWMODEL.name(), IMPORT_VIEW_MODEL_WITH_SUBLIST_PROTOCOL);
		}
	}
}
