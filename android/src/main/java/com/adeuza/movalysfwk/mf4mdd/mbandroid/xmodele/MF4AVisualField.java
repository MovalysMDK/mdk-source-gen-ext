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
import org.dom4j.Element;

import com.a2a.adjava.xmodele.MEnumeration;
import com.a2a.adjava.xmodele.MLabel;
import com.a2a.adjava.xmodele.MVisualField;
import com.a2a.adjava.xmodele.ui.view.MVFLabelKind;
import com.a2a.adjava.xmodele.ui.view.MVFLocalization;

public class MF4AVisualField extends MVisualField {

	public MF4AVisualField(String p_sPath, MVisualField p_oField, MLabel p_oLabel) {
		super(p_sPath, p_oField, p_oLabel);
	}

	public MF4AVisualField(String p_sName, MLabel p_oLabel,
			String p_sComponent, MVFLabelKind p_oLabelKind,
			String p_sAttributeName, boolean p_bMandatoryKind) {
		super(p_sName, p_oLabel, p_sComponent, p_oLabelKind, p_sAttributeName, p_bMandatoryKind);
	}

	public MF4AVisualField(String p_sName, MLabel p_oLabel,
			String p_sComponent, MVFLabelKind p_oLabelKind,
			MVFLocalization p_oTarget, String p_sAttributeName,
			boolean p_bMandatoryKind) {
		super(p_sName, p_oLabel, p_sComponent, p_oLabelKind, p_oTarget, p_sAttributeName, p_bMandatoryKind);
	}

	public MF4AVisualField(String p_sName, MLabel p_oLabel, String p_sComponent, String p_sEditType,
			int p_iMaxLength, int p_iPrecision, int p_iScale, MVFLabelKind p_oLabelKind, MVFLocalization p_oTarget,
			String p_sEntityAttributeName, boolean p_bMandatoryKind, MEnumeration p_oEnum) {
		super(p_sName, p_oLabel, p_sComponent, p_sEditType, p_iMaxLength, p_iPrecision, p_iScale, p_oLabelKind, p_oTarget,
				p_sEntityAttributeName, p_bMandatoryKind, p_oEnum, null);
	}
	
	@Override
	public Element toXml() {
		Element r_xVisualField = super.toXml();
		Element xMultiPanelConfig = r_xVisualField.element("multipanel-config");
		if ( xMultiPanelConfig != null ) {
			String sName = r_xVisualField.elementText("name");
			// main__mainscreen__visualpanel
			String sFirstPart = StringUtils.substringBeforeLast(sName, "__");
			String sLastPart = StringUtils.substringAfterLast(sName, "__");
			
			String sScrollViewId = sFirstPart + "scrollview__" + sLastPart;
			String sContainerViewId = sFirstPart + "container__" + sLastPart;
			
			xMultiPanelConfig.addAttribute("scroll-view-id", sScrollViewId);
			xMultiPanelConfig.addAttribute("container-view-id", sContainerViewId);
			
			for( Element xColumn : (List<Element>) xMultiPanelConfig.element("managment-details").elements("column")) {
				for(Element xSection : (List<Element>) xColumn.elements("managment-detail")) {
					
					String sFrameLayoutId = sFirstPart + "sect" + xSection.attributeValue("section") + "__" + sLastPart;
					xSection.addAttribute("container-id", sFrameLayoutId);
				}
			}
		}
		return r_xVisualField;
	}
}
