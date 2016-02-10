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
package com.adeuza.movalysfwk.mf4mdd.mbandroid.mupdater;

import java.util.Map;

import com.a2a.adjava.mupdater.AbstractMUpdater;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MLabel;
import com.a2a.adjava.xmodele.MLayout;
import com.a2a.adjava.xmodele.MVisualField;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4AModeleFactory;

/**
 * @author lmichenaud
 *
 */
public class AddPromptOnSpinnerUpdater extends AbstractMUpdater {

	/**
	 * (non-Javadoc)
	 * @see com.a2a.adjava.mupdater.MUpdater#execute(com.a2a.adjava.xmodele.XDomain, java.util.Map)
	 */
	@Override
	public void execute(IDomain<IModelDictionary, IModelFactory> p_oDomain, Map<String, ?> p_oGlobalSession) throws Exception {
		for( MLayout oLayout : p_oDomain.getDictionnary().getAllLayouts()) {
			for( MVisualField oVisualField: oLayout.getFields()) {
				if ( oVisualField.getComponent().equals("com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMSpinner")
						|| oVisualField.getComponent().equals("com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMSearchSpinner")) {
					
					p_oDomain.getDictionnary().addLabel(
						((MF4AModeleFactory) p_oDomain.getXModeleFactory()).createLabelFromPrompt(oVisualField));
				}
			}
		}
	}
}
