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
package com.adeuza.movalysfwk.mf4mdd.w8.extractor;

import com.a2a.adjava.uml.UmlModel;
import com.a2a.adjava.uml2xmodele.extractors.AbstractExtractor;
import com.a2a.adjava.xmodele.*;
import com.a2a.adjava.xmodele.ui.menu.MMenu;
import com.a2a.adjava.xmodele.ui.menu.MMenuItem;
import com.adeuza.movalysfwk.mf4mdd.w8.xmodele.MF4WNavigation;
import com.adeuza.movalysfwk.mf4mdd.w8.xmodele.MF4WViewModel;
import org.dom4j.Element;

/**
 * Processor used to add specific features to W8 viewmodels :
 * - add lower camel case property name
 */
public class MF4WScreenProcessor extends AbstractExtractor<IDomain<IModelDictionary,IModelFactory>> {

	/**
	 * {@inheritDoc}
	 * @param p_xConfig configuration element
	 * @throws Exception
	 */
	@Override
	public void initialize(Element p_xConfig) throws Exception {
		// Do nothing
	}

	/**
	 * {@inheritDoc}
	 * @param p_oModele uml model
	 * @throws Exception
	 */
	@Override
	public void extract(UmlModel p_oModele) throws Exception {

		for (MScreen oScreen : this.getDomain().getDictionnary().getAllScreens()) {
			for (MMenu menu : oScreen.getMenus()) {
				for (MMenuItem item : menu.getMenuItems()) {
					//((MF4WViewModel) oScreen.getViewModel()).addNavigation((MF4WNavigation) item.getNavigation());
					((MF4WViewModel) this.getDomain().getDictionnary().getViewModel(oScreen.getViewModel().getFullName()))
							.addNavigation((MF4WNavigation) item.getNavigation());
				}
			}
		}
	}
}
