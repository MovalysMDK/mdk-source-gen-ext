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
package com.adeuza.movalysfwk.mf4mdd.ios.extractor;

import java.util.List;

import com.a2a.adjava.languages.ios.xmodele.views.MIOSSection;
import com.a2a.adjava.xmodele.MViewModelImpl;
import com.adeuza.movalysfwk.mf4mdd.commons.extractor.DataLoaderExtractor;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoader;
import com.adeuza.movalysfwk.mf4mdd.ios.xmodele.MF4IDictionnary;
import com.adeuza.movalysfwk.mf4mdd.ios.xmodele.MF4IDomain;
import com.adeuza.movalysfwk.mf4mdd.ios.xmodele.MF4IModelFactory;

/**
 * MF4I DataLoader
 * @author lmichenaud
 *
 */
public class MF4IDataLoaderExtractor extends DataLoaderExtractor<MF4IDomain<MF4IDictionnary,MF4IModelFactory>> {

	/**
	 * {@inheritDoc}
	 */
	@Override
	protected void computeImports(MDataLoader p_oDataLoader) {
		// nothing to do
	}
	
	/**
	 * {@inheritDoc}
	 * @see com.adeuza.movalysfwk.mf4mdd.commons.extractor.DataLoaderExtractor#computeImportsForViewModel(com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MDataLoader, com.a2a.adjava.xmodele.MViewModelImpl)
	 */
	@Override
	protected void computeImportsForViewModel(MDataLoader p_oDataLoader,
			MViewModelImpl p_oViewModelImpl) {
		super.computeImportsForViewModel(p_oDataLoader, p_oViewModelImpl);
		
		// Set dataloader on section
		List<MIOSSection> oAllSectionsByModel = getDomain().getDictionnary().getAllIOSSectionByViewModel(p_oViewModelImpl);
		for (MIOSSection oSection : oAllSectionsByModel) {
			oSection.setDataloader(p_oDataLoader.getName());
		}
	}
}
