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

import org.dom4j.Element;

import com.a2a.adjava.xmodele.MAction;
import com.a2a.adjava.xmodele.ui.menu.MMenuActionItem;

public class MF4AMenuActionItem extends MMenuActionItem {

	public MF4AMenuActionItem(String p_sId) {
		super(p_sId);
	}

	@Override
	public Element toXml() {
		Element r_oElement = super.toXml();
		
		Element name = r_oElement.addElement("method-name");
		if (this.getScreen() != null) {
			name.addText(this.getScreen().getName());
		} else {
			name.addText("Workspace");
		}
		Element actions = r_oElement.addElement("actions");
		for (MAction action : this.getActions()) {
			actions.add(action.toXml());
		}
		return r_oElement;
	}

}
