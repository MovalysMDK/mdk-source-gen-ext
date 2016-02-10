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

import org.apache.commons.lang3.StringUtils;
import org.dom4j.Element;

import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.MPackage;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelType;
import com.a2a.adjava.xmodele.ui.viewmodel.mappings.IVMMappingDesc;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFViewModel;

/**
 * Ios specific view model class
 */
public class MF4IViewModel extends MFViewModel {

	/**
	 * Constructor
	 * @param p_sName name of the view model
	 * @param p_sUmlName uml name of the view model
	 * @param p_oPackage package of the view model
	 * @param p_sType type of the view model
	 * @param p_oEntityToUpdate entity updated by the view model
	 * @param p_sPath path of the view model
	 * @param p_bCustomizable customizable attribute
	 * @param p_oMapping mapping
	 */
	public MF4IViewModel(String p_sName, String p_sUmlName,
			MPackage p_oPackage, ViewModelType p_sType,
			MEntityImpl p_oEntityToUpdate, String p_sPath,
			boolean p_bCustomizable, IVMMappingDesc p_oMapping) {
		super(p_sName, p_sUmlName, p_oPackage, p_sType, p_oEntityToUpdate, p_sPath,
				p_bCustomizable, p_oMapping);
	}

	@Override
	public Element toXml() {
		Element r_xViewModel = super.toXml();
		
		Element xMapping = (Element) r_xViewModel.element("mapping");
		if ( xMapping != null ) {
			for( Element xElem : (List<Element>) xMapping.elements("entity")) {
				if ( "vmlist".equals(xElem.attributeValue("mapping-type"))) {
					Element xGetter = xElem.element("getter");
					String sMethodName = StringUtils.join("add", StringUtils.capitalize(xGetter.attributeValue("name")), "Object");
					xGetter.addAttribute("add-method", sMethodName);
				}
			}
		}
		return r_xViewModel;
	}
}
