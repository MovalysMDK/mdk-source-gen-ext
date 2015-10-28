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
package com.adeuza.movalysfwk.mf4mdd.w8.generators;

import org.dom4j.Document;

import com.a2a.adjava.languages.w8.generators.VMInterfaceGenerator;
import com.a2a.adjava.languages.w8.xmodele.MW8ImportDelegate;
import com.a2a.adjava.xmodele.MAttribute;
import com.a2a.adjava.xmodele.MViewModelImpl;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelType;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFViewModel;
import com.adeuza.movalysfwk.mf4mdd.w8.xmodele.MF4WImportDelegate;

/**
 * Viewmodel interface generator
 * @author lmichenaud
 *
 */
public class MF4WVmInterfaceGenerator extends VMInterfaceGenerator {

	private static String PARAMETER_VIEWMODEL_HAS_SUBLIST_KEY = "hasSublist";

	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.generator.impl.ViewModelInterfaceGenerator#computeXml(com.a2a.adjava.xmodele.MViewModelImpl)
	 */
	@Override
	protected Document computeXml(MViewModelImpl p_oMViewModel) {
		Document r_xDoc = super.computeXml(p_oMViewModel);
		
		MFViewModel oVm = (MFViewModel) p_oMViewModel;
		
		MF4WImportDelegate oImportDlg = new MF4WImportDelegate(this);
		if (oVm.getEntityToUpdate() != null ) {
			oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.ENTITIES.name(), oVm.getEntityToUpdate().getMasterInterface().getPackage().getFullName());
		}
		
		if(oVm.getDataLoader() != null) {
			oImportDlg.addImport(MF4WImportDelegate.MF4WImportCategory.DATALOADER.name(), oVm.getDataLoader().getPackage().getFullName());
		}

		for(MViewModelImpl oExtVM : oVm.getExternalViewModels())
		{
			oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.VIEWMODEL.name(), oExtVM.getPackage().getFullName());
		}
		
		for( MViewModelImpl oSubVm : oVm.getSubViewModels()) {
			checkForProtocolImports(oVm, oImportDlg);
			oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.VIEWMODEL.name(), oSubVm.getPackage().getFullName());
			for( MViewModelImpl oSubSubVm : oSubVm.getSubViewModels()) {
				checkForProtocolImports(oVm, oImportDlg);
				oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.VIEWMODEL.name(), oSubSubVm.getPackage().getFullName());
			}
		}
		
		r_xDoc.getRootElement().add(oImportDlg.toXml());
		
		return r_xDoc ;
	}
	
	private void checkForProtocolImports(MViewModelImpl oViewModel, MF4WImportDelegate oImportDlg) {
		if(oViewModel.getParameters().get(PARAMETER_VIEWMODEL_HAS_SUBLIST_KEY) != null ) {
			//oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.VIEWMODEL.name(), IMPORT_VIEW_MODEL_WITH_SUBLIST_PROTOCOL);
			oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.VIEWMODEL.name(), oViewModel.getPackage().getFullName());
		}
	}
}
