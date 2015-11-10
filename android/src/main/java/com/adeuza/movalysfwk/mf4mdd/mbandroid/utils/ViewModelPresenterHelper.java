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
package com.adeuza.movalysfwk.mf4mdd.mbandroid.utils;

import org.apache.commons.lang3.StringUtils;

import com.a2a.adjava.types.ITypeDescription;
import com.a2a.adjava.utils.VersionHandler;
import com.a2a.adjava.xmodele.MAttribute;
import com.a2a.adjava.xmodele.MMethodParameter;
import com.a2a.adjava.xmodele.MMethodSignature;
import com.a2a.adjava.xmodele.MViewModelImpl;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelType;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4ADictionnary;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4ADomain;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4AModeleFactory;

public class ViewModelPresenterHelper {

	public static void addAttribute(MViewModelImpl p_oMViewModel, MF4ADomain<MF4ADictionnary,MF4AModeleFactory> p_oDomain) {
		if ("mdkwidget".equals(VersionHandler.getWidgetVariant().getStringWidget())
				&& p_oMViewModel.getType() == ViewModelType.LISTITEM_1) {
			
			// Add MDKPresenter attribute
			String sName = "presenter";
			p_oDomain.getLanguageConf().getTypeDescriptions();
			ITypeDescription oVMTypeDescription = p_oDomain.getLanguageConf().getTypeDescription("MDKPresenter");
			MAttribute oAttribute = p_oDomain.getXModeleFactory().createMAttribute(sName, "private", false, true, true, oVMTypeDescription, "presenter view model", true);
//			MAttribute oAttribute = p_oProject.getDomain().getXModeleFactory().createMAttribute(sName, "private", false, true, true, oVMTypeDescription, "new MDKPresenter()", "null", false, 0, 0, 0, false, false, "null", "presenter view model");
//			MAttribute oAttribute2 = p_oProject.getDomain().getXModeleFactory().createMAttribute(sName, "private", false, true, true,
//					oVMTypeDescription, StringUtils.EMPTY, StringUtils.EMPTY, false,
//					-1, -1, -1, false, false, null, StringUtils.EMPTY);
//			oAttribute = p_oProject.getDomain().getXModeleFactory().createMAttribute(p_sName, p_sVisibility, p_bIdentifier, p_bDerived, p_bTranscient, p_oTypeDescription, p_sDocumentation)
//			oAttribute = p_oProject.getDomain().getXModeleFactory().createMAttribute(p_sName, p_sVisibility, p_bIdentifier, p_bDerived, p_bTransient, p_oTypeDescription, p_sDocumentation, p_bReadOnly)
			oAttribute.setInitialisation("new MDKPresenter()");
			
			p_oMViewModel.addAttribute(oAttribute);
			
			String sBaseName = StringUtils.capitalize(sName);
			
			MMethodSignature oGet = new MMethodSignature(computeGetterName(sBaseName), "public", "get", oVMTypeDescription);
			p_oMViewModel.getMasterInterface().addMethodSignature(oGet);

			MMethodSignature oSet = new MMethodSignature(computeSetterName(sBaseName), "public", "set", null);
			oSet.addParameter(new MMethodParameter("p_o" + sName, oVMTypeDescription));
			p_oMViewModel.getMasterInterface().addMethodSignature(oSet);
//			
//			p_oMViewModel.addImport("com.soprasteria.movalysmdk.widget.basic.model.MDKPresenter");
		}
	}

	private static String computeSetterName(String p_sBaseName) {
		return "set"+p_sBaseName;
	}

	private static String computeGetterName(String p_sBaseName) {
		return "get"+p_sBaseName;
	}
	
	

}
